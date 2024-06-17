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
            ForEach(viewModel.state.prayers, id: \.date.readable) { model in
                if Int(model.date.gregorian.day) == viewModel.state.currentDay {
                    Text(model.date.readable)
                        .font(Constants.Title.font)
                        .foregroundStyle(Constants.Title.color)
                    SinglePrayerTimeView(model: model.timings)
                }
            }
        }
        .overlay {
            if viewModel.state.isLoading || viewModel.state.prayers.isEmpty {
                LoadingView(text: "Loading...")
            }
        }
        .onAppear(perform: {
            viewModel.action.send(.fetchAzon)
            viewModel.action.send(.requestNotification)
            viewModel.action.send(.scheduleNotification)
        })
    }
}
