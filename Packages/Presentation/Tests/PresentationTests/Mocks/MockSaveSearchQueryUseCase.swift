//
//  MockSaveSearchQueryUseCase.swift
//  PresentationTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockSaveSearchQueryUseCase: SaveSearchQueryUseCase, @unchecked Sendable {
    var executeCallCount = 0
    var executeLastQuery: String?
    var executeResult: Error?

    func execute(searchQuery: String) async throws {
        executeCallCount += 1
        executeLastQuery = searchQuery

        if let error = executeResult {
            throw error
        }
    }
}
