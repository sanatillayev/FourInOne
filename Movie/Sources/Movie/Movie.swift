//
//  Movie.swift
//
//
//  Created by Bilol Sanatillayev on 16/06/24.
//

import Foundation

struct Movie: Decodable {
    let title: String?
    let year: String?
    let id: String?
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imbdID"
        case poster = "Poster"
    }
}

struct MovieResponse: Decodable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
