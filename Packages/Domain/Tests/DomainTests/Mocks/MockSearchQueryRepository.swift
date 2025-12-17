//
//  MockSearchQueryRepository.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockSearchQueryRepository: SearchQueryRepository, @unchecked Sendable {
    var saveCallCount = 0
    var saveLastQuery: String?
    var saveResult: Error?

    var fetchAllCallCount = 0
    var fetchAllLastQuery: String?
    var fetchAllLastLimit: Int?
    var fetchAllResult: Result<[SearchQuery], Error> = .success([])

    var fetchOneCallCount = 0
    var fetchOneLastQuery: String?
    var fetchOneResult: Result<SearchQuery?, Error> = .success(nil)

    var removeCallCount = 0
    var removeLastQuery: String?
    var removeResult: Error?

    var removeAllCallCount = 0
    var removeAllResult: Error?

    func save(searchQuery: String) async throws {
        saveCallCount += 1
        saveLastQuery = searchQuery
        if let error = saveResult {
            throw error
        }
    }

    func fetchAll(query: String?, limit: Int) async throws -> [SearchQuery] {
        fetchAllCallCount += 1
        fetchAllLastQuery = query
        fetchAllLastLimit = limit

        switch fetchAllResult {
        case .success(let queries):
            return queries
        case .failure(let error):
            throw error
        }
    }

    func fetchOne(query: String) async throws -> SearchQuery? {
        fetchOneCallCount += 1
        fetchOneLastQuery = query

        switch fetchOneResult {
        case .success(let query):
            return query
        case .failure(let error):
            throw error
        }
    }

    func remove(searchQuery: String) async throws {
        removeCallCount += 1
        removeLastQuery = searchQuery
        if let error = removeResult {
            throw error
        }
    }

    func removeAll() async throws {
        removeAllCallCount += 1
        if let error = removeAllResult {
            throw error
        }
    }
}
