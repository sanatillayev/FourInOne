//
//  NewsView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

public struct NewsView: View {
    
    @StateObject var viewModel: NewsViewModel
    @StateObject var coordinator: NewsCoordinator
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.articles, id: \.title) { article in
                    newsCard(for: article)
                }
                if viewModel.state.isLoadingForNewArticle {
                    HStack {
                        Spacer()
                        LoadingView(text: "Loading more articles...")
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .refreshable {
            viewModel.action.send(.refresh)
        }
        .overlay {
            if viewModel.state.isLoading {
                LoadingView(text: "Loading...")
                    .onAppear {
                        viewModel.action.send(.fetchNews)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func newsCard(for article: Article) -> some View {
        ArticleCardView(article: article) {
        }
        .onAppear {
            if viewModel.state.articles.last?.title == article.title {
                viewModel.action.send(.loadMoreNews)
            }
        }
    }
}
