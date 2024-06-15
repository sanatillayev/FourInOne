//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 14/06/24.
//

import YandexMapsMobile
import CoreLocation
import SwiftUI
import Combine

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    let mapView: YMKMapView = YMKMapView(frame: CGRect.zero)
    lazy var map : YMKMap = {
        return mapView.mapWindow.map
    }()
    
    @Published var lastUserLocation: CLLocation? = nil
//    @Published var centerLocation: YMKPoint? = nil

    let centerLocationSubject = PassthroughSubject<YMKPoint, Never>()

    override init(){
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        map.addCameraListener(with: self)
        map.isRotateGesturesEnabled = false
    }
    
    private func centerMapLocation(target location: YMKPoint?, map: YMKMapView) {
        guard let location = location else { print("Failed to get user location"); return }
        map.mapWindow.map.move(
            with: YMKCameraPosition(target: location, zoom: 10, azimuth: 0, tilt: 0)
        )
        
        mapView.mapWindow.map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .bottom))
        let verticalPadding: UInt = 400
        mapView.mapWindow.map.logo.setPaddingWith(YMKLogoPadding(horizontalPadding: 0, verticalPadding: verticalPadding))
    }
    
    func currentUserLocation(){
        if let myLocation = lastUserLocation {
            centerMapLocation(target: YMKPoint(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude), map: mapView)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastUserLocation = locations.last
        if let location = locations.last {
            centerMapLocation(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        manager.stopUpdatingLocation()
    }
    private func centerMapLocation(target location: YMKPoint?) {
        guard let location = location else { print("Failed to get user location"); return }
        map.move(
            with: YMKCameraPosition(target: location, zoom: 10, azimuth: 0, tilt: 0)
        )
        mapView.mapWindow.map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .bottom))
        let verticalPadding: UInt = 400
        mapView.mapWindow.map.logo.setPaddingWith(YMKLogoPadding(horizontalPadding: 0, verticalPadding: verticalPadding))
        
    }
}


extension LocationManager: YMKMapCameraListener {
    func onCameraPositionChanged(
        with map: YMKMap,
        cameraPosition: YMKCameraPosition,
        cameraUpdateReason: YMKCameraUpdateReason,
        finished: Bool
    ) {
        if finished {
            centerLocationSubject.send(cameraPosition.target)
        }
    }
}
