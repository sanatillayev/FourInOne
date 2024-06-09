//
//  NewsWorker.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation
import Combine
import CoreModel

protocol AnyNewsWorker {
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsResponse
}

final class NewsWorker: AnyNewsWorker {
    private let apiKey = "d2176e261d9b40f2b85a1d0563311eee"
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    private let country = "us"
    
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
        
        return newsResponse
    }
}


