//
//  GitHubRepository.swift
//  Domain
//
//  Created by rick on 12/16/25.
//

public protocol GitHubRepository: Sendable {
    func fetchRepositories(query: String, page: Int) async throws -> GitHubRepoPage
}
