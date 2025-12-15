//
//  SwiftDataStorage.swift
//  Data
//
//  Created by rick on 12/15/25.
//

import SwiftData

public class SwiftDataStorage {
    
    public let container: ModelContainer
    
    public init(inMemory: Bool = false) throws {
        let schema = Schema([SearchQueryEntity.self])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        
        self.container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }
}
