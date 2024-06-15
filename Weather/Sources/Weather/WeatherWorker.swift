//
//  WeatherWorker.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation
import Combine
import CoreModel

protocol AnyWeatherWorker {
    func fetchWeather(lat: String, lon: String) async throws -> WeatherResponse
}

final class WeatherWorker: AnyWeatherWorker {
    private let apiKey = "fb820d609024a14e9e095be95b4bd3db"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    func fetchWeather(lat: String, lon: String) async throws -> WeatherResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return weatherResponse
    }
}
