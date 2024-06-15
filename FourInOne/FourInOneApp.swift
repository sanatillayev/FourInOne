//
//  FourInOneApp.swift
//  FourInOne
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

@main
struct FourInOneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainBuilder.createMainView(selectedTabSection: .azon)
            }
        }
    }
}
