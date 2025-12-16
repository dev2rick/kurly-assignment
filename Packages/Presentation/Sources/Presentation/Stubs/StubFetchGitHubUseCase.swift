//
//  StubFetchGitHubUseCase.swift
//  Presentation
//
//  Created by rick on 12/16/25.
//

import Domain

final class StubFetchGitHubUseCase: FetchGitHubRepoUseCase {
    func execute(query: String, page: Int) async throws -> GitHubRepoPage {
        GitHubRepoPage(
            page: 1,
            totalCount: 1000,
            items: [
                .init(title: "swift", description: "swiftlang", thumbnailUrl: "https://avatars.githubusercontent.com/u/42816656?v=4", url: "https://github.com/swiftlang/swift"),
                .init(title: "swift", description: "openstack", thumbnailUrl: "https://avatars.githubusercontent.com/u/324574?v=4", url: "https://github.com/openstack/swift"),
                .init(title: "swift", description: "tensorflow", thumbnailUrl: "https://avatars.githubusercontent.com/u/15658638?v=4", url: "https://github.com/tensorflow/swift")
            ]
        )
    }
}
