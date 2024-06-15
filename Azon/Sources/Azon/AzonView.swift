//
//  AzonView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

private enum Constants {
    enum Title {
        static let font = Font.system(size: 22.0, weight: .bold)
        static let color = Color.primary
    }
}

public struct AzonView: View {
    
    @StateObject var viewModel: AzonViewModel
    @StateObject var coordinator: AzonCoordinator

    public var body: some View {
            VStack(spacing: 16){
                Text("Azon is here")
                prayerTimesView
            }
            .onAppear(perform: {
                viewModel.action.send(.requestNotification)
                viewModel.action.send(.scheduleNotification)
            })
    }
    
    private var prayerTimesView: some View {
        ForEach(0..<5) { index in
            HStack {
                Text(viewModel.state.names[index])
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(viewModel.state.times[index].toString())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
    }
}
