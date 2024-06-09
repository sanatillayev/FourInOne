//
//  WeatherBuilder.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

public final class WeatherBuilder {
    public static func createWeatherScene(
        presentationType: Binding<Bool>
    ) -> WeatherView {
        let coordinator = WeatherCoordinator(presentationType: presentationType)
        let worker = WeatherWorker()
        let viewModel = WeatherViewModel(worker: worker)
        let view = WeatherView(viewModel: viewModel, coordinator: coordinator)
        return view
    }
}


