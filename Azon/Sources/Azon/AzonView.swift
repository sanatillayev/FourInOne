//
//  AzonView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

public struct AzonView: View {
    
    @StateObject var viewModel: AzonViewModel
    @StateObject var coordinator: AzonCoordinator

    public var body: some View {
            VStack(spacing: 32){
                Text("Azon is here")
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
