//
//  MainView.swift
//  FourInOne
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

struct MainView: View {
    
    @State private var selectedTabSection: TabSection
    @StateObject var coordinator: MainCoordinator

    // MARK: - Life Cycle

    init(selectedTabSection: TabSection = TabSection.azon, coordinator: MainCoordinator) {
        self.selectedTabSection = selectedTabSection
        self._coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        TabView(selection: $selectedTabSection) {
            ForEach(TabSection.allCases, id: \.hashValue) { tab in
                createScreen(for: tab)
                    .tag(tab)
            }
        }
        .safeAreaInset(edge: .bottom) {
            TabBarView(selectedSection: $selectedTabSection)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func createScreen(for tab: TabSection) -> some View {
        switch tab {
        case .azon:
            coordinator.createAzonScene()
        case .news:
            coordinator.createNewsScene()
        case .weather:
            coordinator.createWeatherScene()
        case .movie:
            coordinator.createMovieScene()
        }
    }
}

