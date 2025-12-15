//
//  StubFetchSearchQueryUseCase.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import Domain

final class StubFetchSearchQueryUseCase: FetchSearchQueryUseCase {
    func execute(query: String?, limit: Int) async throws -> [SearchQuery] {
        ["Swift", "RxSwift", "Combine", "Swift Concurrency"].map {
            SearchQuery(query: $0)
        }
    }
}
