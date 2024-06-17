//
//  MovieView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

public struct MovieView: View {
    
    @StateObject var viewModel: MovieViewModel
    @StateObject var coordinator: MovieCoordinator
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                mainView
                    .offset(x: viewModel.state.isMenuOpen ? geometry.size.width * 0.6 : 0)
                SideMenuView(
                    allDidTap: { viewModel.action.send(.showAllMovies) },
                    likedDidTap: { viewModel.action.send(.showLikedMovies) },
                    popularDidTap: { viewModel.action.send(.showPopularMovies) }
                )
                .frame(width: geometry.size.width * 0.6)
                .offset(x: viewModel.state.isMenuOpen ? 0 : -geometry.size.width * 0.6)
                
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        onChanged(value: value, geometry: geometry)
                    }
                    .onEnded { value in
                        onEnded(value: value, geometry: geometry)
                    }
            )
            .animation(.easeInOut, value: viewModel.state.isMenuOpen)
            .safeAreaInset(edge: .top, content: {
                buttonView
                    .offset(x: viewModel.state.isMenuOpen ? geometry.size.width * 0.6 : 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Material.ultraThick)
            })
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        switch viewModel.state.currentScreen {
        case .grid:
            gridView
        case .likedMovies:
            LikedMoviesView()
        case .popularMovies:
            PopularMoviesView()
        }
    }
    
    private var buttonView: some View {
        HStack {
            Button(action: {
                withAnimation {
                    viewModel.action.send(.toggleSideMenu)
                }
            }) {
                Image(systemName: "sidebar.left")
                    .padding()
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                    .padding(.trailing, 24)
            }
            Spacer()
            Button(action: {
                viewModel.action.send(.changeLayout)
            }) {
                Image(systemName: viewModel.state.currentIconName)
                    .padding()
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                    .padding(.leading, 24)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var gridView: some View {
        ScrollView {
            VStack {
                SearchBarView(searchText: searchTextBinding)
                    .padding()
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: viewModel.state.columns),
                    spacing: 20
                ) {
                    ForEach(viewModel.state.movies, id: \.poster) { movie in
                        movieView(for: movie)
                        
                    }
                }
                .animation(.easeInOut, value: viewModel.state.columns)
                .padding()
            }
        }
        .refreshable {
            viewModel.action.send(.fetchMovies)
        }
        .overlay {
            if viewModel.state.isLoading || viewModel.state.movies.isEmpty {
                LoadingView(text: "Loading...")
                    .onAppear {
                        viewModel.action.send(.fetchMovies)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func  movieView(for movie: Movie) -> some View {
        MovieCardView(model: movie, columns: viewModel.state.columns)
            .onAppear {
                if viewModel.state.movies.last?.title == movie.title {
                    viewModel.action.send(.fetchMore)
                }
            }
            .frame(height: 100)
    }
}

// MARK: Functions

extension MovieView {
    private func onChanged(value: DragGesture.Value, geometry: GeometryProxy) {
        if viewModel.state.isMenuOpen {
            viewModel.state.offset = value.translation.width + viewModel.state.lastOffset
            if viewModel.state.offset < 0 {
                viewModel.state.offset = 0
            }
        } else {
            viewModel.state.offset = value.translation.width
            if viewModel.state.offset > 0 {
                viewModel.state.offset = 0
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value, geometry: GeometryProxy) {
        let threshold: CGFloat = geometry.size.width * 0.2
        
        if viewModel.state.isMenuOpen {
            if value.translation.width < -threshold {
                withAnimation {
                    viewModel.state.isMenuOpen = false
                    viewModel.state.offset = 0
                }
            } else {
                withAnimation {
                    viewModel.state.offset = geometry.size.width * 0.6
                }
            }
        } else {
            if value.translation.width > threshold {
                withAnimation {
                    viewModel.state.isMenuOpen = true
                    viewModel.state.offset = geometry.size.width * 0.6
                }
            } else {
                withAnimation {
                    viewModel.state.offset = 0
                }
            }
        }
        viewModel.state.lastOffset = viewModel.state.offset
    }
    
    private func updateOffset(geometry: GeometryProxy) {
        viewModel.state.offset = viewModel.state.isMenuOpen ? geometry.size.width * 0.6 : 0
        viewModel.state.lastOffset = viewModel.state.offset
    }
}

extension MovieView {
    private var searchTextBinding: Binding<String> {
        Binding {
            viewModel.state.searchText
        } set: {
            viewModel.action.send(.setSearchText($0))
        }
    }
    
    private var searchIsPresentedBinding: Binding<Bool> {
        Binding {
            viewModel.state.isSearchPresented
        } set: {
            viewModel.action.send(.setSearchPresented($0))
        }
    }
}
