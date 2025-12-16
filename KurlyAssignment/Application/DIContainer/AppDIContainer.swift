//
//  AppDIContainer.swift
//  KurlyAssignment
//
//  Created by rick on 12/16/25.
//

import Foundation
import Data

final class AppDIContainer {
    
    lazy var persistenceStorage: SwiftDataStorage = {
        do {
            return try SwiftDataStorage()
        } catch {
            fatalError("Persistence storage initialization failed.")
        }
    }()
    
    lazy var apiService: GitHubAPIService = {
        GitHubAPIServiceImpl(logger: DefaultNetworkLogger())
    }()
    
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            persistenceStorage: persistenceStorage,
            apiService: apiService
        )
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
