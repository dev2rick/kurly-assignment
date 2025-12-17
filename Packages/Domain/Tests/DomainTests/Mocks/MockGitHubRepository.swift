//
//  MockGitHubRepository.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import Foundation
@testable import Domain

final class MockGitHubRepository: GitHubRepository, @unchecked Sendable {
    var fetchRepositoriesCallCount = 0
    var fetchRepositoriesLastQuery: String?
    var fetchRepositoriesLastPage: Int?
    var fetchRepositoriesResult: Result<GitHubRepoPage, Error> = .success(
        GitHubRepoPage(page: 1, totalCount: 0, items: [])
    )

    func fetchRepositories(query: String, page: Int) async throws -> GitHubRepoPage {
        fetchRepositoriesCallCount += 1
        fetchRepositoriesLastQuery = query
        fetchRepositoriesLastPage = page

        switch fetchRepositoriesResult {
        case .success(let page):
            return page
        case .failure(let error):
            throw error
        }
    }
}
