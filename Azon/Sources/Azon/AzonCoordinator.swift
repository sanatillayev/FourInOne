//
//  AzonCoordinator.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Router
import SwiftUI

final class AzonCoordinator: Router {
    
    override init(presentationType: Binding<Bool>) {
        super.init(presentationType: presentationType)
    }
    
    func closeView() {
        self.dismiss()
    }
}
