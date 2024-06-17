//
//  SinglePrayerTimeView.swift
//
//
//  Created by Bilol Sanatillayev on 16/06/24.
//

import SwiftUI

private enum Constants {
    enum Title {
        static let font = Font.system(size: 22.0, weight: .bold)
        static let color = Color.primary
    }
}

struct SinglePrayerTimeView: View {
    
    let model: Timing
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Fajr")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Fajr.extractTime())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
            HStack {
                Text("Sunrise")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Sunrise.extractTime())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
            HStack {
                Text("Dhuhr")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Dhuhr.extractTime())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
            HStack {
                Text("Asr")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Asr.extractTime())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
            HStack {
                Text("Maghrib")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Maghrib.extractTime())
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
            }
            .padding(.all)
            .background(.regularMaterial)
            .cornerRadius(8)
            HStack {
                Text("Isha")
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Spacer()
                Text(model.Isha.extractTime())
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

extension String {
    func extractTime() -> String {
        guard self.count >= 5 else { return self }
        return String(self.prefix(5))
    }
}
