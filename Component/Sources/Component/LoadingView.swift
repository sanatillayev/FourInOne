//
//  LoadingView.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

private enum Constants {
    static let spacing: CGFloat = 8.0
    static let font = Font.system(size: 16.0)
}

public struct LoadingView: View {

    let text: String
    let color: Color

    public init(text: String, color: Color = .green) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        HStack(spacing: Constants.spacing) {
            ProgressView() 
                .tint(color)

            Text(text)
                .font(Constants.font)
                .foregroundColor(color)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
        .transition(.opacity)
    }
}
