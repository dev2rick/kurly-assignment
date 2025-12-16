//
//  AppDIContainer.swift
//  KurlyAssignment
//
//  Created by rick on 12/16/25.
//

import Foundation
import Data

final class AppDIContainer {
    
    let persistenceStorage: SwiftDataStorage
    
    init() {
        do {
            persistenceStorage = try SwiftDataStorage()
        } catch {
            fatalError("Persistence storage initialization failed.")
        }
    }
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            persistenceStorage: persistenceStorage
        )
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
