//
//  MockFetchSearchQueryUseCase.swift
//  PresentationTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockFetchSearchQueryUseCase: FetchSearchQueryUseCase, @unchecked Sendable {
    var executeCallCount = 0
    var executeLastQuery: String?
    var executeLastLimit: Int?
    var executeResult: Result<[SearchQuery], Error> = .success([])

    func execute(query: String?, limit: Int) async throws -> [SearchQuery] {
        executeCallCount += 1
        executeLastQuery = query
        executeLastLimit = limit

        switch executeResult {
        case .success(let queries):
            return queries
        case .failure(let error):
            throw error
        }
    }
}
