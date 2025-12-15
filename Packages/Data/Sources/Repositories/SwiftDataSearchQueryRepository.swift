//
//  SwiftDataSearchQueryRepository.swift
//  Data
//
//  Created by rick on 12/15/25.
//

import SwiftData
import Domain
import Foundation

@ModelActor
final public actor SwiftDataSearchQueryRepository: SearchQueryRepository {
    
    public func save(searchQuery: String) async throws {
        
        let item = try await fetchOneEntity(query: searchQuery)
        
        if let item {
            item.updatedAt = Date()
            modelContext.insert(item)
        } else {
            let newItem = SearchQueryEntity(
                query: searchQuery,
                updatedAt: Date(),
                createdAt: Date()
            )
            modelContext.insert(newItem)
        }
        try modelContext.save()
    }
    
    public func fetchAll(query: String?, limit: Int) async throws -> [SearchQuery] {
        var descriptor: FetchDescriptor<SearchQueryEntity>
        if let query {
            let predicate = #Predicate<SearchQueryEntity> {
                $0.query.contains(query)
            }
            descriptor = FetchDescriptor(predicate: predicate)
            
        } else {
            descriptor = FetchDescriptor()
        }
        descriptor.fetchLimit = limit
        descriptor.sortBy = [SortDescriptor(\SearchQueryEntity.updatedAt, order: .reverse)]
        return try modelContext.fetch(descriptor).map(\.toDomain)
    }
    
    public func fetchOne(query: String) async throws -> SearchQuery? {
        try await fetchOneEntity(query: query)?.toDomain
    }
    
    public func remove(searchQuery: String) async throws {
        if let target = try await fetchOneEntity(query: searchQuery) {
            modelContext.delete(target)
            try modelContext.save()
        }
    }
    
    public func removeAll() async throws {
        try modelContext.delete(model: SearchQueryEntity.self)
        try modelContext.save()
    }
}

extension SwiftDataSearchQueryRepository {
    private func fetchOneEntity(query: String) async throws -> SearchQueryEntity? {
        let predicate = #Predicate<SearchQueryEntity> {
            $0.query == query
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try modelContext.fetch(descriptor).first
    }
}
