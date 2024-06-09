//
//  MainCoordinator.swift
//  FourInOne
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Router
import Azon
import News
import Weather
import Movie

final class MainCoordinator: Router {

    override init(presentationType: Binding<Bool>) {
        super.init(presentationType: presentationType)
    }

    func createAzonScene() -> AzonView {
        AzonBuilder.createAzonScene(presentationType: .constant(true))
    }
    
    func createNewsScene() -> NewsView {
        NewsBuilder.createNewsScene(presentationType: .constant(true))
    }
    
    func createWeatherScene() -> WeatherView {
        WeatherBuilder.createWeatherScene(presentationType: .constant(true))
    }
    
    func createMovieScene() -> MovieView {
        MovieBuilder.createMovieScene(presentationType: .constant(true))
    }
}

