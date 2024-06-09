//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Component

private enum Constants {
    
    static let mainVerticalSpacing: CGFloat = 10
    static let hPadding: CGFloat = 16.0
    static let vPadding: CGFloat = 16.0
    static let cornerRadius: CGFloat = 16.0
    
    enum Title {
        static let font = Font.system(size: 22.0, weight: .bold)
        static let color = Color.primary
    }
    
    enum Description {
        static let font = Font.system(size: 17)
        static let color = Color.secondary
    }
    
    enum Image {
        static let cornerRadius : CGFloat = 10
        static let notLoadedImage : String = "photo"
        static let height: CGFloat = width / 2
        static let width: CGFloat = UIScreen.main.bounds.width - 64
    }
}

struct ArticleCardView: View {
    
    // MARK: - Properties
    private let article: Article
    private let onTapAction: () -> Void
    
    // MARK: - Life Cycle
    
    
    init(article: Article, onTapAction: @escaping () -> Void) {
        self.article = article
        self.onTapAction = onTapAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.mainVerticalSpacing) {
            VStack(alignment: .center, spacing: Constants.mainVerticalSpacing) {
                Text(article.title ?? "")
                    .font(Constants.Title.font)
                    .foregroundColor(Constants.Title.color)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(article.description ?? "")
                    .font(Constants.Description.font)
                    .foregroundColor(Constants.Description.color)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                imageView(from: article.urlToImage ?? "")
            }
            .onTapGesture {
                onTapAction()
            }
        }
        .padding(.horizontal, Constants.hPadding)
        .padding(.vertical, Constants.vPadding)
        .background(.white.opacity(0.2))
        .cornerRadius(Constants.cornerRadius)
    }
    
    // MARK: - Additional Views
    
    private func imageView(from urlString: String) -> some View {
        
        let url = URL(string: urlString)
        return AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable().scaledToFill()
            } else if urlString == "" || phase.error != nil {
                ZStack {
                    LinearGradient.AppGradients.grayPlaceholder
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.primary)
                }
            } else {
                ZStack {
                    GradientPlaceholderView()
                    ProgressView()
                }
            }
        }
        .frame(width: Constants.Image.width)
        .frame(height: Constants.Image.height)
        .cornerRadius(Constants.Image.cornerRadius)
        .clipped()
    }
}

