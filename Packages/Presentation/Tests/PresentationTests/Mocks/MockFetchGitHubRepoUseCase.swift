//
//  MockFetchGitHubRepoUseCase.swift
//  PresentationTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockFetchGitHubRepoUseCase: FetchGitHubRepoUseCase, @unchecked Sendable {
    var executeCallCount = 0
    var executeLastQuery: String?
    var executeLastPage: Int?
    var executeResult: Result<GitHubRepoPage, Error> = .success(
        GitHubRepoPage(page: 1, totalCount: 0, items: [])
    )
    var delayNanoseconds: UInt64 = 0

    func execute(query: String, page: Int) async throws -> GitHubRepoPage {
        executeCallCount += 1
        executeLastQuery = query
        executeLastPage = page

        // Delay 설정 시 대기 (Task cancellation 테스트용)
        if delayNanoseconds > 0 {
            do {
                try await Task.sleep(nanoseconds: delayNanoseconds)
            } catch {
                if error is CancellationError {
                    // 취소는 Error throws 하지 않도록함.
                } else {
                    throw error
                }   
            }
        }

        switch executeResult {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }
}
