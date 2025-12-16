//
//  GitHubRepository.swift
//  Domain
//
//  Created by rick on 12/16/25.
//

public struct GitHubRepoPage: Sendable {
    public let page: Int
    public let totalCount: Int
    public let items: [GitHubRepo]
    
    public init(
        page: Int,
        totalCount: Int,
        items: [GitHubRepo]
    ) {
        self.page = page
        self.totalCount = totalCount
        self.items = items
    }
}

public struct GitHubRepo: Sendable, Hashable {
    public let title: String
    public let description: String
    public let thumbnailUrl: String
    public let url: String
    
    public init(
        title: String,
        description: String,
        thumbnailUrl: String,
        url: String
    ) {
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.url = url
    }
}
