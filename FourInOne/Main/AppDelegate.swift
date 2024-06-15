//
//  AppDelegate.swift
//  FourInOne
//
//  Created by Bilol Sanatillayev on 14/06/24.
//

import SwiftUI
import YandexMapWarepper

class AppDelegate: NSObject, UIApplicationDelegate {
    let key = "3fd2dbd3-506d-4c1f-a782-cc7d9f1bab57"
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        YandexMapWrapper.run(apiKey: key, locale: "en_US")
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
}
