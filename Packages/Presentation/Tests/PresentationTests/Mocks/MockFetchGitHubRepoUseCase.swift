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

    func execute(query: String, page: Int) async throws -> GitHubRepoPage {
        executeCallCount += 1
        executeLastQuery = query
        executeLastPage = page

        switch executeResult {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }
}
