//
//  WeatherViewModel.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Combine
import CoreModel
import CoreLocation

final class WeatherViewModel: ObservableObject {
    
    // MARK: Public Properties
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties
    
    private let worker: AnyWeatherWorker
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(worker: AnyWeatherWorker) {
        self.worker = worker

        action
            .sink(receiveValue: { [unowned self] in
                self.didChange($0)
            })
            .store(in: &cancellables)
    }
    
    // MARK: Private Methods
    
    private func didChange(_ action: Action) {
        switch action {
        case .fetchWeather(let coordinate):
            fetchWeather(lat: coordinate.latitude.description,
                         lon: coordinate.longitude.description)            
        }
    }
    
    private func fetchWeather(lat: String, lon: String) {
        Task.detached(priority: .high) { @MainActor [unowned self] in
            state.isLoading = true
            do {
                let weather = try await worker.fetchWeather(lat: lat , lon: lon)
                state.weatherModel = .init(conditionId: weather.weather[0].id, name: weather.name, temp: weather.main.temp, description: weather.weather[0].description)
                state.isLoading = false
            } catch {
                print(error)
                state.isLoading = false
            }
        }
    }
    
    // MARK: Public methods
    
    func bind(to locationManager: LocationManager) {
        locationManager.centerLocationSubject
            .sink { [weak self] location in
                guard let self = self else { return }
                self.state.isUpdating = true
                self.action.send(.fetchWeather(CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )))
                self.state.isUpdating = false
            }
            .store(in: &cancellables)
    }
}


// MARK: - ViewModel Actions & State

extension WeatherViewModel {
    
    enum Action {
        case fetchWeather(CLLocationCoordinate2D)
    }
    
    struct State {
        var isLoading = false
        var isUpdating = false
        var weatherModel: WeatherModel = .init(conditionId: 0, name: "", temp: 0, description: "")
    }
}



