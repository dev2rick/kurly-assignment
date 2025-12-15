//
//  SceneDelegate.swift
//  KurlyAssignment
//
//  Created by rick on 12/15/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
       
        let v = UIViewController()
        v.view.backgroundColor = .red
        window.rootViewController = v
        
        window.makeKeyAndVisible()
        
        self.window = window
        
    }
}
