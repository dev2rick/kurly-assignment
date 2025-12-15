//
//  SearchQueryListViewModel.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import Foundation
import Domain

@MainActor
final public class SearchQueryListViewModel: ObservableObject {

    @Published private(set) var searchQueries: [SearchQuery] = []
    @Published private(set) var errorMessage: String?

    private let fetchSearchQueryUseCase: FetchSearchQueryUseCase
    private let saveSearchQueryUseCase: SaveSearchQueryUseCase
    private static let MAX_SIZE: Int = 10

    public init(
        fetchSearchQueryUseCase: FetchSearchQueryUseCase,
        saveSearchQueryUseCase: SaveSearchQueryUseCase
    ) {
        self.fetchSearchQueryUseCase = fetchSearchQueryUseCase
        self.saveSearchQueryUseCase = saveSearchQueryUseCase
    }
    
    private func fetchQueries(query: String?) async {
        do {
            let results = try await fetchSearchQueryUseCase.execute(
                query: query,
                limit: SearchQueryListViewModel.MAX_SIZE
            )
            self.searchQueries = results
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func save(searchQuery: String) async {
        do {
            try await saveSearchQueryUseCase.execute(searchQuery: searchQuery)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Inputs
extension SearchQueryListViewModel {
    func onAppear() async {
        await fetchQueries(query: nil)
    }
    
    func onRefresh(query: String) async {
        await fetchQueries(query: query)
    }
    
    func onSearch(query: String) async {
        await save(searchQuery: query)
    }
}
