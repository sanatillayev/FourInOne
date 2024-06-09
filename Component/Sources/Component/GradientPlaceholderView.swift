//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

struct GradientProgressEffect: AnimatableModifier {
    var position: CGFloat = 0

    var animatableData: CGFloat {
        get {
            position
        } set {
            position = newValue
        }
    }

    func body(content: Content) -> some View {
        content.background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2), location: 0.00),
                    Gradient.Stop(color: Color.primary.opacity(0.4), location: position - 0.05),
                    Gradient.Stop(color: Color.primary.opacity(0.4), location: position + 0.05),
                    Gradient.Stop(color: Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2), location: 1.00)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .padding(.horizontal, -40)
            .clipped()
        )
    }
}

public struct GradientPlaceholderView: View, Animatable {
    @State private var animate = CGFloat(0.1)
    
    public init() { }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 12).fill(.clear)
            .modifier(GradientProgressEffect(position: animate))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onAppear {
                withAnimation(.linear(duration: 2.0)
                    .repeatForever(autoreverses: true)) {
                        animate = 0.9
                }
                
            }
    }
}

