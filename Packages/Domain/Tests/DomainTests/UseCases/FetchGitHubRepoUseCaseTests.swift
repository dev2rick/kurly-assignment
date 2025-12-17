//
//  FetchGitHubRepoUseCaseTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class FetchGitHubRepoUseCaseTests: XCTestCase {
    var sut: DefaultFetchGitHubRepoUseCase!
    var mockRepository: MockGitHubRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockGitHubRepository()
        sut = DefaultFetchGitHubRepoUseCase(githubRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_깃허브_저장소_조회_성공() async throws {
        // Given
        let query = "Swift"
        let page = 1
        let expectedRepos = [
            GitHubRepo(
                title: "swift",
                description: "The Swift Programming Language",
                thumbnailUrl: "https://example.com/swift.png",
                url: "https://github.com/apple/swift"
            ),
            GitHubRepo(
                title: "swift-evolution",
                description: "This maintains proposals for changes and user-visible enhancements to the Swift Programming Language.",
                thumbnailUrl: "https://example.com/swift-evolution.png",
                url: "https://github.com/apple/swift-evolution"
            )
        ]
        let expectedPage = GitHubRepoPage(
            page: page,
            totalCount: 100,
            items: expectedRepos
        )
        mockRepository.fetchRepositoriesResult = .success(expectedPage)

        // When
        let result = try await sut.execute(query: query, page: page)

        // Then
        XCTAssertEqual(mockRepository.fetchRepositoriesCallCount, 1)
        XCTAssertEqual(mockRepository.fetchRepositoriesLastQuery, query)
        XCTAssertEqual(mockRepository.fetchRepositoriesLastPage, page)
        XCTAssertEqual(result.page, expectedPage.page)
        XCTAssertEqual(result.totalCount, expectedPage.totalCount)
        XCTAssertEqual(result.items.count, expectedRepos.count)
        XCTAssertEqual(result.items[0].title, expectedRepos[0].title)
        XCTAssertEqual(result.items[1].title, expectedRepos[1].title)
    }

    func test_깃허브_저장소_조회_빈_결과() async throws {
        // Given
        let query = "nonexistentrepo"
        let page = 1
        let emptyPage = GitHubRepoPage(page: page, totalCount: 0, items: [])
        mockRepository.fetchRepositoriesResult = .success(emptyPage)

        // When
        let result = try await sut.execute(query: query, page: page)

        // Then
        XCTAssertEqual(mockRepository.fetchRepositoriesCallCount, 1)
        XCTAssertEqual(result.items.count, 0)
        XCTAssertEqual(result.totalCount, 0)
    }

    func test_깃허브_저장소_조회_다양한_페이지() async throws {
        // Given
        let query = "Swift"
        let page = 3
        let expectedPage = GitHubRepoPage(
            page: page,
            totalCount: 150,
            items: [
                GitHubRepo(
                    title: "repo1",
                    description: "description",
                    thumbnailUrl: "url",
                    url: "url"
                )
            ]
        )
        mockRepository.fetchRepositoriesResult = .success(expectedPage)

        // When
        let result = try await sut.execute(query: query, page: page)

        // Then
        XCTAssertEqual(mockRepository.fetchRepositoriesLastPage, page)
        XCTAssertEqual(result.page, page)
    }

    // MARK: - Failure Cases

    func test_깃허브_저장소_조회_실패() async throws {
        // Given
        let query = "Swift"
        let page = 1
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.fetchRepositoriesResult = .failure(expectedError)

        // When/Then
        do {
            _ = try await sut.execute(query: query, page: page)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.fetchRepositoriesCallCount, 1)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
