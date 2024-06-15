//
//  CardView.swift
//
//
//  Created by Bilol Sanatillayev on 14/06/24.
//

import SwiftUI

private enum Constants {
    enum Title {
        static let font = Font.system(size: 22.0, weight: .bold)
        static let color = Color.primary
    }
    
    enum Description {
        static let font = Font.system(size: 17)
        static let color = Color.secondary
    }
}
struct CardView: View {
    let title: String
    let description: String
    let temp: String
    let imageName: String
    
    init(model: WeatherModel) {
        self.title = model.name
        self.description = model.description
        self.temp = String(model.temp)
        self.imageName = model.conditionName
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            VStack(alignment: .leading, spacing: 36, content: {
                Text(title)
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Text(description)
                    .font(Constants.Description.font)
                    .foregroundStyle(Constants.Description.color)
            })
            Spacer()
            
            VStack(alignment: .trailing, spacing: 24, content: {
                Text(temp)
                    .font(Constants.Title.font)
                    .foregroundStyle(Constants.Title.color)
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundStyle(Constants.Title.color)
            })
        })
        .padding(.all, 16)
        .frame(maxWidth: .infinity, idealHeight: 160)
        .background(Material.ultraThinMaterial)
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
