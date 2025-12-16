//
//  FetchGitHubRepoUseCase.swift
//  Domain
//
//  Created by rick on 12/16/25.
//

public protocol FetchGitHubRepoUseCase: Sendable {
    func execute(query: String, page: Int) async throws -> GitHubRepoPage
}

final public class DefaultFetchGitHubRepoUseCase: FetchGitHubRepoUseCase {
    private let githubRepository: GitHubRepository
    
    public init(githubRepository: GitHubRepository) {
        self.githubRepository = githubRepository
    }
    
    public func execute(query: String, page: Int) async throws -> GitHubRepoPage {
        try await githubRepository.fetchRepositories(query: query, page: page)
    }
}
