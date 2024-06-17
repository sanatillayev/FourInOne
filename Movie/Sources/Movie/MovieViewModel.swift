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
        case .fetchMovies:
            fetchMovies()
        case .fetchMore:
            fetchMore()
        case .changeLayout:
            changeLayout()
            updateIcon()
        case .toggleSideMenu:
            state.isMenuOpen.toggle()
            state.isSearchPresented = !state.isMenuOpen
        case .showAllMovies:
            state.currentScreen = .grid
            state.isMenuOpen = false
        case .showLikedMovies:
            state.currentScreen = .likedMovies
            state.isMenuOpen = false
        case .showPopularMovies:
            state.currentScreen = .popularMovies
            state.isMenuOpen = false
        case .setSearchText(let newText):
            state.searchText = newText
            state.currentPageNumber = 1
            fetchMovies()
        case .setSearchPresented(let newValue):
            state.isSearchPresented = newValue
        }
    }
    
    private func changeLayout() {
        if state.columns < 3 {
            state.columns += 1
        } else {
            state.columns = 1
        }
    }
    
    private func updateIcon() {
        withAnimation(.easeInOut) {
            switch state.columns {
            case 1:
                state.currentIconName = "rectangle.grid.1x2.fill"
            case 2:
                state.currentIconName = "rectangle.grid.2x2.fill"
            case 3:
                state.currentIconName = "square.grid.3x2.fill"
            default:
                state.currentIconName = "rectangle.grid.1x2.fill"
            }
        }
    }
    
    private func fetchMovies() {
        Task.detached(priority: .high) { @MainActor [unowned self] in
            state.isLoading = true
            do {
                let response = try await worker.fetchMovies(
                    page: state.currentPageNumber,
                    search: state.searchText
                )
                state.movies = response.search
                state.isLoading = false
            } catch {
                print("Error: \(error)")
                state.isLoading = false
            }
        }
    }
    
    private func fetchMore() {
        guard !state.isAllPagesShown else { return }
        Task.detached(priority: .high) { @MainActor [unowned self] in
            do {
                let response = try await worker.fetchMovies(
                    page: state.currentPageNumber + 1,
                    search: state.searchText
                )
                state.movies += response.search
                state.isLoadingForNewMovies = false
                state.currentPageNumber += 1
                state.isAllPagesShown = state.movies.count == Int(response.totalResults) ||
                state.movies.count >= 30
            } catch {
                print(error)
                state.isLoadingForNewMovies = false
            }
        }
    }
}

// MARK: - ViewModel Actions & State

extension MovieViewModel {
    
    enum Screen {
        case grid
        case likedMovies
        case popularMovies
    }
    
    enum Action {
        case changeLayout
        case fetchMovies
        case fetchMore
        case toggleSideMenu
        case showAllMovies
        case showLikedMovies
        case showPopularMovies
        case setSearchText(String)
        case setSearchPresented(Bool)
    }
    
    struct State {
        var isLoading = false
        var columns: Int = 1
        var isMenuOpen: Bool = false
        var isSearchPresented: Bool = false
        var offset: CGFloat = 0
        var lastOffset: CGFloat = 0
        var currentScreen: Screen = .grid
        var currentIconName: String = "rectangle.grid.1x2.fill"
        var currentPageNumber: Int = 1
        var searchText: String = "Batman"
        var movies: [Movie] = []
        var isAllPagesShown: Bool = false
        var isLoadingForNewMovies: Bool = false
    }
}
