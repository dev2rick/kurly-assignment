//
//  MainSceneFlowCoordinator.swift
//  Presentation
//
//  Created by rick on 12/16/25.
//

import SwiftUI
import Domain
import SafariServices

public protocol MainFlowCoordinatorDependencies {
    func makeSearchQueryListView(actions: SearchQueryListViewModelActions) -> SearchQueryListView
}

@MainActor
public final class MainFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies
    
    public init(
        navigationController: UINavigationController,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    public func start() {
        let actions = SearchQueryListViewModelActions(showGitHubRepo: showGitHubRepo)
        let view = dependencies.makeSearchQueryListView(actions: actions)
        let viewController = UIHostingController(rootView: view)
        viewController.title = "Search"
        navigationController?.pushViewController(viewController, animated: false)
    }

    private func showGitHubRepo(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        navigationController?.present(safariVC, animated: true)
    }
}
