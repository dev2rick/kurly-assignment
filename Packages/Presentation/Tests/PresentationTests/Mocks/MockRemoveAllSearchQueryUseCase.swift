//
//  MockRemoveAllSearchQueryUseCase.swift
//  PresentationTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockRemoveAllSearchQueryUseCase: RemoveAllSearchQueryUseCase, @unchecked Sendable {
    var executeCallCount = 0
    var executeResult: Error?

    func execute() async throws {
        executeCallCount += 1

        if let error = executeResult {
            throw error
        }
    }
}
