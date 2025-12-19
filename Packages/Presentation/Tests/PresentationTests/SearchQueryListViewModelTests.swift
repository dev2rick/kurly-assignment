//
//  SearchQueryListViewModelTests.swift
//  PresentationTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
import Domain
@testable import Presentation

@MainActor
final class SearchQueryListViewModelTests: XCTestCase {
    var sut: SearchQueryListViewModel!
    var mockFetchSearchQuery: MockFetchSearchQueryUseCase!
    var mockSaveSearchQuery: MockSaveSearchQueryUseCase!
    var mockRemoveSearchQuery: MockRemoveSearchQueryUseCase!
    var mockRemoveAllSearchQuery: MockRemoveAllSearchQueryUseCase!
    var mockFetchGitHubRepo: MockFetchGitHubRepoUseCase!
    var actionsShowGitHubRepoCallCount = 0
    var actionsShowGitHubRepoLastURL: URL?

    override func setUp() async throws {
        try await super.setUp()
        mockFetchSearchQuery = MockFetchSearchQueryUseCase()
        mockSaveSearchQuery = MockSaveSearchQueryUseCase()
        mockRemoveSearchQuery = MockRemoveSearchQueryUseCase()
        mockRemoveAllSearchQuery = MockRemoveAllSearchQueryUseCase()
        mockFetchGitHubRepo = MockFetchGitHubRepoUseCase()
        actionsShowGitHubRepoCallCount = 0
        actionsShowGitHubRepoLastURL = nil

        sut = SearchQueryListViewModel(
            fetchSearchQueryUseCase: mockFetchSearchQuery,
            saveSearchQueryUseCase: mockSaveSearchQuery,
            removeSearchQueryUseCase: mockRemoveSearchQuery,
            removeAllSearchQueryUseCase: mockRemoveAllSearchQuery,
            fetchGitHubRepoUseCase: mockFetchGitHubRepo,
            actions: SearchQueryListViewModelActions(
                showGitHubRepo: { [weak self] url in
                    self?.actionsShowGitHubRepoCallCount += 1
                    self?.actionsShowGitHubRepoLastURL = url
                }
            )
        )
    }

    override func tearDown() async throws {
        sut = nil
        mockFetchSearchQuery = nil
        mockSaveSearchQuery = nil
        mockRemoveSearchQuery = nil
        mockRemoveAllSearchQuery = nil
        mockFetchGitHubRepo = nil
        actionsShowGitHubRepoCallCount = 0
        actionsShowGitHubRepoLastURL = nil
        try await super.tearDown()
    }

    // MARK: - onAppear 테스트

    func test_onAppear_빈_쿼리로_검색_목록_조회() async throws {
        // Given
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date()),
            SearchQuery(query: "iOS", updatedAt: Date(), createdAt: Date())
        ]
        mockFetchSearchQuery.executeResult = .success(expectedQueries)

        // When
        await sut.onAppear()

        // Then
        XCTAssertEqual(mockFetchSearchQuery.executeCallCount, 1)
        XCTAssertNil(mockFetchSearchQuery.executeLastQuery)
        XCTAssertEqual(mockFetchSearchQuery.executeLastLimit, 10)
        XCTAssertEqual(sut.cachedQueries.count, 2)
        XCTAssertEqual(sut.cachedQueries[0].query, "Swift")
        XCTAssertEqual(sut.cachedQueries[1].query, "iOS")
    }

    func test_onAppear_검색_쿼리_조회_실패() async throws {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchSearchQuery.executeResult = .failure(expectedError)

        // When
        await sut.onAppear()

        // Then
        XCTAssertEqual(mockFetchSearchQuery.executeCallCount, 1)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - query 변경 테스트

    func test_query_변경시_빈_문자열로_전체_목록_조회() async throws {
        // Given
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date())
        ]
        mockFetchSearchQuery.executeResult = .success(expectedQueries)

        // When
        sut.query = ""
        // debounce 대기
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15초

        // Then
        XCTAssertEqual(mockFetchSearchQuery.executeCallCount, 1)
        XCTAssertNil(mockFetchSearchQuery.executeLastQuery)
        XCTAssertTrue(sut.githubRepos.isEmpty)
    }

    func test_query_변경시_쿼리_필터링() async throws {
        // Given
        let query = "Swift"
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date()),
            SearchQuery(query: "SwiftUI", updatedAt: Date(), createdAt: Date())
        ]
        mockFetchSearchQuery.executeResult = .success(expectedQueries)

        // When
        sut.query = query
        // debounce 대기
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15초

        // Then
        XCTAssertEqual(mockFetchSearchQuery.executeCallCount, 1)
        XCTAssertEqual(mockFetchSearchQuery.executeLastQuery, query)
        XCTAssertEqual(sut.cachedQueries.count, 2)
    }

    // MARK: - onSubmit 테스트

    func test_onSubmit_쿼리_저장_및_저장소_검색() async throws {
        // Given
        let query = "Swift"
        sut.query = query
        let expectedRepos = [
            GitHubRepo(
                title: "swift",
                description: "The Swift Programming Language",
                thumbnailUrl: "https://example.com/swift.png",
                url: "https://github.com/apple/swift"
            )
        ]
        let expectedPage = GitHubRepoPage(page: 1, totalCount: 100, items: expectedRepos)
        mockFetchGitHubRepo.executeResult = .success(expectedPage)

        // When
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result

        // Then
        XCTAssertEqual(mockSaveSearchQuery.executeCallCount, 1)
        XCTAssertEqual(mockSaveSearchQuery.executeLastQuery, query)
        XCTAssertEqual(mockFetchGitHubRepo.executeCallCount, 1)
        XCTAssertEqual(mockFetchGitHubRepo.executeLastQuery, query)
        XCTAssertEqual(mockFetchGitHubRepo.executeLastPage, 1)
        XCTAssertEqual(sut.githubRepos.count, 1)
        XCTAssertEqual(sut.githubRepos[0].title, "swift")
    }

    func test_onSubmit_로딩_상태_변경() async throws {
        // Given
        sut.query = "Swift"
        let expectedPage = GitHubRepoPage(page: 1, totalCount: 0, items: [])
        mockFetchGitHubRepo.executeResult = .success(expectedPage)

        // When
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result

        // Then
        XCTAssertFalse(sut.isLoading)
    }

    func test_onSubmit_저장소_검색_실패() async throws {
        // Given
        sut.query = "Swift"
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchGitHubRepo.executeResult = .failure(expectedError)

        // When
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result

        // Then
        XCTAssertEqual(mockSaveSearchQuery.executeCallCount, 1)
        XCTAssertEqual(mockFetchGitHubRepo.executeCallCount, 1)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - onTapItem 테스트

    func test_onTapItem_쿼리_저장_및_저장소_검색() async throws {
        // Given
        let query = "iOS"
        let expectedRepos = [
            GitHubRepo(
                title: "ios",
                description: "iOS Development",
                thumbnailUrl: "https://example.com/ios.png",
                url: "https://github.com/ios/ios"
            )
        ]
        let expectedPage = GitHubRepoPage(page: 1, totalCount: 50, items: expectedRepos)
        mockFetchGitHubRepo.executeResult = .success(expectedPage)

        // When
        sut.onTapItem(query)
        _ = await sut.fetchGitHubRepoTask?.result

        // Then
        XCTAssertEqual(sut.query, query)
        XCTAssertEqual(mockSaveSearchQuery.executeCallCount, 1)
        XCTAssertEqual(mockSaveSearchQuery.executeLastQuery, query)
        XCTAssertEqual(mockFetchGitHubRepo.executeCallCount, 1)
        XCTAssertEqual(mockFetchGitHubRepo.executeLastQuery, query)
        XCTAssertEqual(sut.githubRepos.count, 1)
    }

    // MARK: - removeAll 테스트

    func test_removeAll_전체_삭제_및_목록_갱신() async throws {
        // Given
        // 초기 상태에 캐시된 쿼리가 있다고 가정
        mockFetchSearchQuery.executeResult = .success([
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date())
        ])
        await sut.onAppear()
        XCTAssertEqual(sut.cachedQueries.count, 1)

        // When
        await sut.removeAll()

        // Then
        XCTAssertEqual(mockRemoveAllSearchQuery.executeCallCount, 1)
        XCTAssertTrue(sut.cachedQueries.isEmpty)
    }

    func test_removeAll_삭제_실패() async throws {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRemoveAllSearchQuery.executeResult = expectedError

        // When
        await sut.removeAll()

        // Then
        XCTAssertEqual(mockRemoveAllSearchQuery.executeCallCount, 1)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - remove 테스트

    func test_remove_개별_삭제_및_목록_갱신() async throws {
        // Given
        let query = "Swift"
        let remainingQueries = [
            SearchQuery(query: "iOS", updatedAt: Date(), createdAt: Date())
        ]
        mockFetchSearchQuery.executeResult = .success(remainingQueries)

        // When
        await sut.remove(query)

        // Then
        XCTAssertEqual(mockRemoveSearchQuery.executeCallCount, 1)
        XCTAssertEqual(mockRemoveSearchQuery.executeLastQuery, query)
        XCTAssertEqual(mockFetchSearchQuery.executeCallCount, 1)
        XCTAssertNil(mockFetchSearchQuery.executeLastQuery)
        XCTAssertEqual(sut.cachedQueries.count, 1)
        XCTAssertEqual(sut.cachedQueries[0].query, "iOS")
    }

    func test_remove_삭제_실패() async throws {
        // Given
        let query = "Swift"
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRemoveSearchQuery.executeResult = expectedError

        // When
        await sut.remove(query)

        // Then
        XCTAssertEqual(mockRemoveSearchQuery.executeCallCount, 1)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - onTapRepo 테스트

    func test_onTapRepo_유효한_URL로_액션_호출() {
        // Given
        let repo = GitHubRepo(
            title: "swift",
            description: "desc",
            thumbnailUrl: "https://example.com/thumb.png",
            url: "https://github.com/apple/swift"
        )

        // When
        sut.onTapRepo(repo)

        // Then
        XCTAssertEqual(actionsShowGitHubRepoCallCount, 1)
        XCTAssertEqual(actionsShowGitHubRepoLastURL?.absoluteString, repo.url)
    }

    func test_onTapRepo_잘못된_URL로_액션_미호출() {
        // Given
        let repo = GitHubRepo(
            title: "swift",
            description: "desc",
            thumbnailUrl: "https://example.com/thumb.png",
            url: ""
        )

        // When
        sut.onTapRepo(repo)

        // Then
        XCTAssertEqual(actionsShowGitHubRepoCallCount, 0)
        XCTAssertNil(actionsShowGitHubRepoLastURL)
    }

    // MARK: - 초기 상태 테스트

    func test_초기_상태_검증() {
        // Then
        XCTAssertEqual(sut.query, "")
        XCTAssertTrue(sut.githubRepos.isEmpty)
        XCTAssertTrue(sut.cachedQueries.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.page, 1)
    }

    // MARK: - 페이지네이션 테스트

    func test_onSubmit_저장소_목록_초기화() async throws {
        // Given
        sut.query = "Swift"
        let firstRepos = [
            GitHubRepo(title: "repo1", description: "desc1", thumbnailUrl: "url1", url: "url1")
        ]
        let secondRepos = [
            GitHubRepo(title: "repo2", description: "desc2", thumbnailUrl: "url2", url: "url2")
        ]

        // When - 첫 번째 검색
        mockFetchGitHubRepo.executeResult = .success(
            GitHubRepoPage(page: 1, totalCount: 100, items: firstRepos)
        )
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result
        XCTAssertEqual(sut.githubRepos.count, 1)

        // When - 두 번째 검색 (onSubmit은 항상 githubRepos를 초기화)
        mockFetchGitHubRepo.executeResult = .success(
            GitHubRepoPage(page: 1, totalCount: 100, items: secondRepos)
        )
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result

        // Then - 새로운 검색이므로 기존 결과는 초기화되고 새로운 결과만 표시
        XCTAssertEqual(sut.githubRepos.count, 1)
        XCTAssertEqual(sut.githubRepos[0].title, "repo2")
        XCTAssertEqual(sut.page, 2) // 페이지는 증가
    }

    func test_onLoadMore_저장소_목록_누적() async throws {
        // Given
        sut.query = "Swift"
        let firstRepos = [
            GitHubRepo(title: "repo1", description: "desc1", thumbnailUrl: "url1", url: "url1")
        ]
        let secondRepos = [
            GitHubRepo(title: "repo2", description: "desc2", thumbnailUrl: "url2", url: "url2")
        ]

        // When - 첫 번째 검색
        mockFetchGitHubRepo.executeResult = .success(
            GitHubRepoPage(page: 1, totalCount: 100, items: firstRepos)
        )
        sut.onSubmit()
        _ = await sut.fetchGitHubRepoTask?.result
        XCTAssertEqual(sut.githubRepos.count, 1)

        // When - 페이지 로드 (onLoadMore는 githubRepos에 누적)
        mockFetchGitHubRepo.executeResult = .success(
            GitHubRepoPage(page: 2, totalCount: 100, items: secondRepos)
        )
        sut.onLoadMore(item: firstRepos[0])
        _ = await sut.fetchGitHubRepoTask?.result

        // Then - 기존 결과에 새 결과가 누적
        XCTAssertEqual(sut.githubRepos.count, 2)
        XCTAssertEqual(sut.githubRepos[0].title, "repo1")
        XCTAssertEqual(sut.githubRepos[1].title, "repo2")
        XCTAssertEqual(sut.page, 3)
    }
}
