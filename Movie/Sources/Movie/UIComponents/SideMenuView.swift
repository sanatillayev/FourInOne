//
//  SideMenuView.swift
//
//
//  Created by Bilol Sanatillayev on 15/06/24.
//

import SwiftUI

struct SideMenuView: View {
    let allDidTap: (() -> Void)
    let likedDidTap: (() -> Void)
    let popularDidTap: (() -> Void)
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.gray.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Button(action: allDidTap) {
                    Text("All Movies")
                        .padding()
                }
                Button(action: likedDidTap) {
                    Text("Liked Movies")
                        .padding()
                }
                
                Button(action: popularDidTap) {
                    Text("Popular Movies")
                        .padding()
                }
                Spacer()
            }
            .tint(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
