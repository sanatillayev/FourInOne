//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 16/06/24.
//

import SwiftUI
import Component

private enum Constants {
    enum Title {
        static let font = Font.system(size: 16.0, weight: .semibold)
        static let color = Color.primary
    }
    enum Description {
        static let font = Font.system(size: 14)
        static let color = Color.secondary
    }
    enum Image {
        static let cornerRadius : CGFloat = 10
        static let notLoadedImage : String = "photo"
        static let height: CGFloat = 300
        static let width: CGFloat = 150
    }
}
struct MovieCardView: View {
    let model: Movie
    let columns: Int
    
    var body: some View {
        GeometryReader { geometry in
            if columns == 1 {
                HStack(alignment: .top, spacing: 16) {
                    imageView(from: model.poster ?? "")
                        .scaledToFill()
                        .frame(width: geometry.size.width/3, height: geometry.size.height)
                        .clipped()
                    VStack(alignment: .leading, spacing: 16) {
                        Text(model.title ?? "")
                            .font(Constants.Title.font)
                            .foregroundStyle(Constants.Title.color)
                        Text(model.year ?? "")
                            .font(Constants.Description.font)
                            .foregroundStyle(Constants.Description.color)
                    }
                }
            } else if columns == 2 {
                ZStack(alignment: .bottom) {
                    imageView(from: model.poster ?? "")
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    Text(model.title ?? "")
                        .font(Constants.Title.font)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(4)
                        .frame(width: geometry.size.width, alignment: .leading)
                        .background(Color.black.opacity(0.6))
                }
            } else if columns == 3 {
                ZStack(alignment: .bottom) {
                    imageView(from: model.poster ?? "")
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    Text(model.title ?? "")
                        .font(Constants.Description.font)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(4)
                        .frame(width: geometry.size.width, alignment: .leading)
                        .background(Color.black.opacity(0.6))
                }
            }
        }
    }
    
    private func imageView(from urlString: String) -> some View {
        let url = URL(string: urlString)
        return AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
            } else if urlString == "" || phase.error != nil {
                ZStack {
                    LinearGradient.AppGradients.grayPlaceholder
                    Image(systemName: Constants.Image.notLoadedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.primary)
                }
            } else {
                ZStack {
                    GradientPlaceholderView()
                    ProgressView()
                }
            }
        }
        .cornerRadius(Constants.Image.cornerRadius)
        .clipped()
    }
}

