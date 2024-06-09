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
//    func fetchOffers() -> AnyPublisher<OfferModel, Error>
}

final class MovieWorker: AnyMovieWorker {
        
    let offersURL = URL(string: "https://run.mocky.io/v3/214a1713-bac0-4853-907c-a1dfc3cd05fd")!
    
//    func fetchOffers() -> AnyPublisher<OfferModel, Error> {
//        URLSession.shared.dataTaskPublisher(for: offersURL)
//            .map(\.data)
//            .decode(type: OfferModel.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
}



