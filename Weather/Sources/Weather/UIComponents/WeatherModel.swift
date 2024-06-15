//
//  WeatherModel.swift
//  
//
//  Created by Bilol Sanatillayev on 14/06/24.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let name: String
    let temp: Double
    let description: String
    
    var tempString: String {
        String(format: "%.1f", temp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct WeatherResponse: Decodable {
    var name: String
    var coord: Coord
    var weather: [Weather]
    var main: Main
}

struct Coord: Decodable {
    var lon: Float
    var lat: Float
}
struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}
