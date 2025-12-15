//
//  FetchSearchQueryUseCase.swift
//  Domain
//
//  Created by rick on 12/15/25.
//

import Foundation

public protocol FetchSearchQueryUseCase: Sendable {
    func execute(query: String?, limit: Int) async throws -> [SearchQuery]
}

final public class DefaultFetchSearchQueryUseCase: FetchSearchQueryUseCase {
    
    private let searchQueryRepository: SearchQueryRepository
    
    public init(searchQueryRepository: SearchQueryRepository) {
        self.searchQueryRepository = searchQueryRepository
    }
    
    public func execute(query: String?, limit: Int) async throws -> [SearchQuery] {
        try await searchQueryRepository.fetchAll(query: query, limit: limit)
    }
}
