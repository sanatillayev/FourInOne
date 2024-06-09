//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

public extension LinearGradient {
    
    enum AppGradients {
        
        public static let grayPlaceholder: LinearGradient = {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2), location: 0.00),
                    Gradient.Stop(color: Color.primary.opacity(0.1), location: 0.75),
                    Gradient.Stop(color: Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2), location: 1.00)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }()
    }
}

