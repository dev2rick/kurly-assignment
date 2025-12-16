//
//  SceneDelegate.swift
//  KurlyAssignment
//
//  Created by rick on 12/15/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        appFlowCoordinator = AppFlowCoordinator(
            window: window,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        
        window.makeKeyAndVisible()
        
        self.window = window
        
    }
}
