//
//  SearchQueryEntity.swift
//  Data
//
//  Created by rick on 12/15/25.
//

import SwiftData
import Domain
import Foundation

@Model
public class SearchQueryEntity {
    public var query: String
    public var updatedAt: Date
    public var createdAt: Date
    
    init(query: String, updatedAt: Date, createdAt: Date) {
        self.query = query
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}

extension SearchQueryEntity {
    var toDomain: SearchQuery {
        SearchQuery(
            query: query,
            updatedAt: updatedAt,
            createdAt: createdAt
        )
    }
}
