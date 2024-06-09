//
//  MovieViewModel.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Combine
import CoreModel

final class MovieViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties

    private let worker: AnyMovieWorker
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init

    init(worker: AnyMovieWorker) {
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
        case .fetchOffers:
            break
        case .setFrom(let text):
            state.fromText = text
        case .setWhere(let text):
            state.whereText = text
        }
    }
    
//    private func fetchOffers() {
//        state.isLoading = true
//        worker.fetchOffers()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Error while fetching hotel data: \(error)")
//                    self?.state.isLoading = false
//                }
//            }, receiveValue: { [weak self] model in
//                self?.state.offers = model.offers.map({ $0.getOffer() })
//            })
//            .store(in: &cancellables)
//    }
}

// MARK: - ViewModel Actions & State

extension MovieViewModel {
    
    enum Action {
        case fetchOffers
        case setWhere(String)
        case setFrom(String)
    }
    
    struct State {
        var isLoading = false
        var offers: [String] = []
        let images: [String] = ["Image1","Image2","Image3"]
        var fromText: String = ""
        var whereText: String = ""
    }
}




