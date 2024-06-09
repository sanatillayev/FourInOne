//
//  NewsViewModel.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Combine
import CoreModel

final class NewsViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties

    private let worker: AnyNewsWorker
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init

    init(worker: AnyNewsWorker) {
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
        case .fetchNews:
            fetchInitialNews()
        case .loadMoreNews:
            fetchMoreNews()
        case .refresh:
            state.isLoading = true
            state.currentPageNumber = 0
            state.isAllPagesShown = false
            fetchInitialNews()
        case .changePostFromDetail:
            break
        }
    }
    
    
    private func fetchInitialNews() {
        Task.detached(priority: .high) { @MainActor [unowned self] in
            state.isLoading = true
            do {
                let page = try await worker.fetchNews(
                    page: state.currentPageNumber,
                    pageSize: state.paginationPageSize
                )
                state.articles = page.articles ?? []
                state.isLoading = false
            } catch {
                print(error)
                state.isLoading = false
            }
        }
    }
    
    private func fetchMoreNews() {
        guard !state.isAllPagesShown else { return }
        Task.detached(priority: .high) { @MainActor [unowned self] in
            do {
                let pageNews = try await worker.fetchNews(
                    page: state.currentPageNumber + 1,
                    pageSize: state.paginationPageSize
                )
                state.articles += pageNews.articles ?? []
                state.isLoadingForNewArticle = false
                state.currentPageNumber += 1
                state.isAllPagesShown = state.articles.count == pageNews.totalResults
            } catch {
                print(error)
                state.isLoadingForNewArticle = false
            }
        }
    }
}

// MARK: - ViewModel Actions & State

extension NewsViewModel {
    
    enum Action {
        case fetchNews
        case changePostFromDetail
        case loadMoreNews
        case refresh
    }
    
    struct State {
        let paginationPageSize = 5
        var currentPageNumber: Int = 0
        var articles = [Article]()
        var isLoading = true
        var isLoadingForNewArticle = false
        var isAllPagesShown = false
    }
}


