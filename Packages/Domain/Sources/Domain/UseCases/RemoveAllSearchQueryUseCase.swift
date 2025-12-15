//
//  RemoveAllSearchQueryUseCase.swift
//  Domain
//
//  Created by rick on 12/15/25.
//

import Foundation

public protocol RemoveAllSearchQueryUseCase: Sendable {
    func execute() async throws
}

final public class DefaultRemoveAllSearchQueryUseCase: RemoveAllSearchQueryUseCase {
    
    private let searchQueryRepository: SearchQueryRepository
    
    public init(searchQueryRepository: SearchQueryRepository) {
        self.searchQueryRepository = searchQueryRepository
    }
    
    public func execute() async throws {
        try await searchQueryRepository.removeAll()
    }
}
