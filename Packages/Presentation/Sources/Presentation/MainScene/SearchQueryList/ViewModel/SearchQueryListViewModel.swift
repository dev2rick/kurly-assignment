//
//  SearchQueryListViewModel.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import Foundation
import Domain
import Combine

public struct SearchQueryListViewModelActions {
    let showGitHubRepo: (URL) -> Void
}

@MainActor
final public class SearchQueryListViewModel: ObservableObject {

    @Published var query: String = ""
    @Published private(set) var githubRepos: [GitHubRepo] = []
    @Published private(set) var searchQueries: [SearchQuery] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false

    private let fetchSearchQueryUseCase: FetchSearchQueryUseCase
    private let saveSearchQueryUseCase: SaveSearchQueryUseCase
    private let removeSearchQueryUseCase: RemoveSearchQueryUseCase
    private let removeAllSearchQueryUseCase: RemoveAllSearchQueryUseCase
    private let fetchGitHubRepoUseCase: FetchGitHubRepoUseCase
    private let actions: SearchQueryListViewModelActions?
    private var cancellables: Set<AnyCancellable> = []
    private(set) var page: Int = 1
    private static let MAX_SIZE: Int = 10

    public init(
        fetchSearchQueryUseCase: FetchSearchQueryUseCase,
        saveSearchQueryUseCase: SaveSearchQueryUseCase,
        removeSearchQueryUseCase: RemoveSearchQueryUseCase,
        removeAllSearchQueryUseCase: RemoveAllSearchQueryUseCase,
        fetchGitHubRepoUseCase: FetchGitHubRepoUseCase,
        actions: SearchQueryListViewModelActions?
    ) {
        self.fetchSearchQueryUseCase = fetchSearchQueryUseCase
        self.saveSearchQueryUseCase = saveSearchQueryUseCase
        self.removeSearchQueryUseCase = removeSearchQueryUseCase
        self.removeAllSearchQueryUseCase = removeAllSearchQueryUseCase
        self.fetchGitHubRepoUseCase = fetchGitHubRepoUseCase
        self.actions = actions
        subscribes()
    }
    
    func subscribes() {
        $query
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] q in
                Task {
                    await self?.onSearchQueryChange(q)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchQueries(query: String) async {
        do {
            let queryString: String?
            if query.isEmpty {
                githubRepos = []
                queryString = nil
            } else {
                queryString = query
            }
            let results = try await fetchSearchQueryUseCase.execute(
                query: queryString,
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
    
    private func removeAllSearchQueries() async {
        do {
            try await removeAllSearchQueryUseCase.execute()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func remove(searchQuery: String) async {
        do {
            try await removeSearchQueryUseCase.execute(searchQuery: searchQuery)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func fetchRepos(searchQuery: String) async {
        do {
            self.isLoading = true
            let response = try await fetchGitHubRepoUseCase.execute(query: searchQuery, page: page)
            self.githubRepos += response.items
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Inputs
extension SearchQueryListViewModel {
    func onAppear() async {
        await fetchQueries(query: query)
    }
    
    func onSearchQueryChange(_ query: String) async {
        await fetchQueries(query: query)
    }
    
    func onSubmit() async {
        await save(searchQuery: query)
        await fetchRepos(searchQuery: query)
    }
    
    func onTapItem(_ query: String) async {
        self.query = query
        await save(searchQuery: query)
        await fetchRepos(searchQuery: query)
    }
    
    func removeAll() async {
        await removeAllSearchQueries()
        await fetchQueries(query: "")
    }
    
    func remove(_ query: String) async {
        await remove(searchQuery: query)
        await fetchQueries(query: "")
    }
    
    func onTapRepo(_ repo: GitHubRepo) {
        guard let url = URL(string: repo.url) else { return }
        actions?.showGitHubRepo(url)
    }
}
