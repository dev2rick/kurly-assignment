//
//  AppDelegate.swift
//  KurlyAssignment
//
//  Created by rick on 12/15/25.
//


import UIKit

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)

        config.delegateClass = SceneDelegate.self

        return config
    }
}
