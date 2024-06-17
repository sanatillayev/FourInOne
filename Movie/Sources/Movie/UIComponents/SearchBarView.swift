//
//  SearchBarView.swift
//
//
//  Created by Bilol Sanatillayev on 17/06/24.
//

import SwiftUI

private enum Constants {
    
    enum Text {
        static let color = Color.primary
        static let notActive = Color.secondary
    }
    
    enum Field{
        static let color = Color.gray.opacity(0.5)
        static let icon = "magnifyingglass"
        static let text = "Search"
        static let cornerRadius: CGFloat = 10
        static let hOffset: CGFloat = 20
    }
}

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    init(searchText: Binding<String>) {
        _searchText = searchText
    }
    
    var body: some View {
        HStack {
            Image(systemName: Constants.Field.icon)
                .foregroundColor(Constants.Text.color)
                
            TextField(Constants.Field.text, text: $searchText)
                .foregroundColor(Constants.Text.color)
        }
        .font(.headline)
        .padding(.all, 8)
        .background(
            RoundedRectangle(cornerRadius: Constants.Field.cornerRadius)
                .fill(Constants.Field.color)
        )
    }
}
