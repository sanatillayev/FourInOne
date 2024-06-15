//
//  WeatherView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component
import YandexMapsMobile

public struct WeatherView: View {
    
    @StateObject var viewModel: WeatherViewModel
    @StateObject var coordinator: WeatherCoordinator
    @ObservedObject var locationManager = LocationManager()
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            YandexMapView()
                .edgesIgnoringSafeArea(.top)
                .environmentObject(locationManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            cardView
                .overlay {
                    if viewModel.state.isLoading {
                        LoadingView(text: "Loading...", color: .white)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }
                }
        }
        .overlay(alignment: .center, content: {
            if viewModel.state.isLoading {
                ProgressView()
                    .font(.largeTitle)
                    .tint(.black)
            } else {
                Image(systemName: "mappin.and.ellipse")
                    .font(.largeTitle)
                    .foregroundStyle(Color.gray)
            }
        })
        .onAppear {
            locationManager.currentUserLocation()
            viewModel.bind(to: locationManager)
        }
        
    }
    
    @ViewBuilder
    private var cardView: some View {
        if let model = viewModel.state.weatherModel {
            CardView(model: model)
        }
    }
}
