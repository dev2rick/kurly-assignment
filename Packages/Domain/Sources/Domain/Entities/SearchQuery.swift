//
//  SearchQuery.swift
//  Domain
//
//  Created by rick on 12/15/25.
//

import Foundation

public struct SearchQuery: Hashable, Sendable {
    public let query: String
    public let updatedAt: Date
    public let createdAt: Date
    
    public init(
        query: String,
        updatedAt: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.query = query
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
