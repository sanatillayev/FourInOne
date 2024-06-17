//
//  MovieWorker.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation
import Combine
import CoreModel

protocol AnyMovieWorker {
    func fetchMovies(page: Int, search: String) async throws -> MovieResponse
}

final class MovieWorker: AnyMovieWorker {
    private let apiKey = "f1bfcaeb"
    private let baseURL = "https://www.omdbapi.com/"
    private let search = "Batman"
    
    func fetchMovies(page: Int, search: String) async throws -> MovieResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "s", value: search),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let moviesResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        
        return moviesResponse
    }
}



