//
//  MainSceneDIContainer.swift
//  KurlyAssignment
//
//  Created by rick on 12/16/25.
//

import UIKit
import Presentation
import Domain
import Data

final class MainSceneDIContainer: MainFlowCoordinatorDependencies {
    
    struct Dependencies {
        let persistenceStorage: SwiftDataStorage
        let apiService: GitHubAPIService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    private func makeSearchQueryRepository() -> SearchQueryRepository {
        let container = dependencies.persistenceStorage.container
        return SwiftDataSearchQueryRepository(modelContainer: container)
    }
    
    private func makeGitHubRepository() -> GitHubRepository {
        DefaultGitHubRepository(apiService: dependencies.apiService)
    }
    
    // MARK: - UseCases
    private func makeFetchSearchQueryUseCase() -> FetchSearchQueryUseCase {
        DefaultFetchSearchQueryUseCase(
            searchQueryRepository: makeSearchQueryRepository()
        )
    }
    
    private func makeSaveSearchQueryUseCase() -> SaveSearchQueryUseCase {
        DefaultSaveSearchQueryUseCase(
            searchQueryRepository: makeSearchQueryRepository()
        )
    }
    
    private func makeRemoveSearchQueryUseCase() -> RemoveSearchQueryUseCase {
        DefaultRemoveSearchQueryUseCase(
            searchQueryRepository: makeSearchQueryRepository()
        )
    }
    
    private func makeRemoveAllSearchQueryUseCase() -> RemoveAllSearchQueryUseCase {
        DefaultRemoveAllSearchQueryUseCase(
            searchQueryRepository: makeSearchQueryRepository()
        )
    }
    
    private func makeFetchGitHubRepositoryUseCase() -> FetchGitHubRepoUseCase {
        DefaultFetchGitHubRepoUseCase(
            githubRepository: makeGitHubRepository()
        )
    }
    
    // MARK: - Views
    func makeSearchQueryListView(actions: SearchQueryListViewModelActions) -> SearchQueryListView {
        let viewModel = makeSearchQueryListViewModel(actions: actions)
        return SearchQueryListView(viewModel: viewModel)
    }
    
    private func makeSearchQueryListViewModel(actions: SearchQueryListViewModelActions) -> SearchQueryListViewModel {
        SearchQueryListViewModel(
            fetchSearchQueryUseCase: makeFetchSearchQueryUseCase(),
            saveSearchQueryUseCase: makeSaveSearchQueryUseCase(),
            removeSearchQueryUseCase: makeRemoveSearchQueryUseCase(),
            removeAllSearchQueryUseCase: makeRemoveAllSearchQueryUseCase(),
            fetchGitHubRepoUseCase: makeFetchGitHubRepositoryUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Flow Coordinators
    func makeMainFlowCoordinator(navigationController: UINavigationController) -> MainFlowCoordinator {
        MainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
