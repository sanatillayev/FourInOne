//
//  TabSection.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation

public enum TabSection: CaseIterable {
    case azon
    case news
    case weather
    case movie

    public var iconName: String {
        switch self {
        case .azon: return "moon"
        case .news: return "newspaper"
        case .weather: return "cloud.sun.rain"
        case .movie: return "popcorn"
        }
    }

    public var tabTitle: String {
        switch self {
        case .azon: return "Azon"
        case .news: return "News"
        case .weather: return "Weather"
        case .movie: return "Movie"
        }
    }
}
