//
//  DefaultGitHubRepository.swift
//  Data
//
//  Created by rick on 12/16/25.
//

import Domain

public final class DefaultGitHubRepository: GitHubRepository {
    
    private let apiService: GitHubAPIService
    
    public init(apiService: GitHubAPIService) {
        self.apiService = apiService
    }
    
    public func fetchRepositories(query: String, page: Int) async throws -> GitHubRepoPage {
        let endpoint = GitHubAPIEndpoint.fetchRepositories(query: query, page: page)
        let response: GitHubRepoResponseDTO = try await apiService.request(endpoint)
        return GitHubRepoPage(
            page: page,
            totalCount: response.totalCount,
            items: response.items.map(\.toDomain)
        )
    }
}
