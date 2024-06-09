//
//  MainBuilder.swift
//  FourInOne
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import Foundation
import Component

final class MainBuilder {

    static func createMainView(selectedTabSection: TabSection) -> MainView {
        let coordinator = MainCoordinator(presentationType: .constant(false))
        let view = MainView(selectedTabSection: selectedTabSection, coordinator: coordinator)
        return view
    }
}
