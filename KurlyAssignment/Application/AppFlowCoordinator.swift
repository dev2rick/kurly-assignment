//
//  AppFlowCoordinator.swift
//  KurlyAssignment
//
//  Created by rick on 12/16/25.
//

import UIKit
import Presentation

final class AppFlowCoordinator {

    private let window: UIWindow
    private weak var rootViewController: UIViewController?
    private let appDIContainer: AppDIContainer
    
    init(
        window: UIWindow,
        appDIContainer: AppDIContainer
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let rootViewController = UINavigationController()
        
        self.rootViewController = rootViewController
        window.rootViewController = rootViewController
        
        appDIContainer
            .makeMainSceneDIContainer()
            .makeMainFlowCoordinator(navigationController: rootViewController)
            .start()
    }
}
