//
//  AzonView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component
import SwiftData

private enum Constants {
    enum Title {
        static let font = Font.system(size: 22.0, weight: .bold)
        static let color = Color.primary
    }
}

public struct AzonView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var prayers: [PrayerData]

    @StateObject var viewModel: AzonViewModel
    @StateObject var coordinator: AzonCoordinator
    
    public var body: some View {
        VStack(spacing: 16) {
            ForEach(prayers, id: \.id) { model in
                if model.date.extractDay() == viewModel.state.currentDay {
                    Text(model.date)
                        .font(Constants.Title.font)
                        .foregroundStyle(Constants.Title.color)
                    SinglePrayerTimeView(model: Timing(Fajr: model.fajr, Sunrise: model.sunrise, Dhuhr: model.dhuhr, Asr: model.asr, Maghrib: model.maghrib, Isha: model.isha))
                }
            }
        }
        .overlay {
            if viewModel.state.isLoading || prayers.isEmpty {
                LoadingView(text: "Loading...")
            }
        }
        .refreshable {
            viewModel.action.send(.fetchAzon)
        }
        .onAppear(perform: {
            if prayers.isEmpty {
                viewModel.action.send(.fetchAzon)
                saveData()
            }
            viewModel.action.send(.requestNotification)
            viewModel.action.send(.scheduleNotification)
        })
    }
    
    private func saveData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for prayer in viewModel.state.prayers {
                let itemToStore = PrayerData(model: prayer)
                modelContext.insert(itemToStore)
            }
        }
    }
}
