//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation
import Combine
import CoreModel

protocol AnyAzonWorker {
    func fetchAzon(year: String, month: String) async throws -> AzonResponse
}

final class AzonWorker: AnyAzonWorker {
   
//      "https://api.aladhan.com/v1/calendarByCity/2024/6?
//        city=Tashkent&country=uz&method=3&school=1"
 
 
    private let baseURL = "https://api.aladhan.com/v1/calendarByCity/"
    private let city = "Tashkent"
    private let country = "uz"
    private let method = "3" // World Islam Leage Calculation
    private let school = "1" // HANAFI

    
    func fetchAzon(year: String, month: String) async throws -> AzonResponse {
        guard var urlComponents = URLComponents(string: baseURL+year+"/"+month) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "school", value: school)
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AzonResponse.self, from: data)
        
        return response
    }
}

