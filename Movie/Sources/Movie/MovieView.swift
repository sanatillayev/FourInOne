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
            VStack(spacing: 32){
                Text("Movie is here")
            }
            .onAppear(perform: {
                viewModel.action.send(.fetchOffers)
            })
    }
    
    
    private var scrollView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Музыкально отлететь")
                .font(.system(size: 22, weight: .semibold))
                .padding(. horizontal, 16)
        }
    }
}
