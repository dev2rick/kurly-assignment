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

final class StubSaveSearchQueryUseCase: SaveSearchQueryUseCase {
    func execute(searchQuery: String) async throws { }
}

final class StubRemoveSearchQueryUseCase: RemoveSearchQueryUseCase {
    func execute(searchQuery: String) async throws { }
}

final class StubRemoveAllSearchQueryUseCase: RemoveAllSearchQueryUseCase {
    func execute() async throws { }
}
