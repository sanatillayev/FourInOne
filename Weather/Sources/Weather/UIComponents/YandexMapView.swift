//
//  YandexMapView.swift
//  
//
//  Created by Bilol Sanatillayev on 14/06/24.
//

import SwiftUI
import YandexMapsMobile

struct YandexMapView: UIViewRepresentable {
    
    @EnvironmentObject var locationManager : LocationManager
    
    func makeUIView(context: Context) -> YMKMapView {
        let mapView = locationManager.mapView
        
        return mapView
    }
    func updateUIView(_ mapView: YMKMapView, context: Context) {}
}
