//
//  SaveSearchQueryUseCase.swift
//  Domain
//
//  Created by rick on 12/15/25.
//

import Foundation

public protocol SaveSearchQueryUseCase: Sendable {
    func execute(searchQuery: String) async throws
}

final public class DefaultSaveSearchQueryUseCase: SaveSearchQueryUseCase {
    
    private let searchQueryRepository: SearchQueryRepository
    
    public init(searchQueryRepository: SearchQueryRepository) {
        self.searchQueryRepository = searchQueryRepository
    }
    
    public func execute(searchQuery: String) async throws {
        try await searchQueryRepository.save(searchQuery: searchQuery)
    }
}
