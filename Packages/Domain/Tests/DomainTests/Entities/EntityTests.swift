//
//  EntityTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class SearchQueryTests: XCTestCase {

    func test_검색_쿼리_초기화() {
        // Given
        let query = "Swift"
        let now = Date()

        // When
        let searchQuery = SearchQuery(
            query: query,
            updatedAt: now,
            createdAt: now
        )

        // Then
        XCTAssertEqual(searchQuery.query, query)
        XCTAssertEqual(searchQuery.updatedAt, now)
        XCTAssertEqual(searchQuery.createdAt, now)
    }

    func test_검색_쿼리_날짜_표시() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let testDate = dateFormatter.date(from: "2025-12-17")!

        let searchQuery = SearchQuery(
            query: "Swift",
            updatedAt: testDate,
            createdAt: testDate
        )

        // When
        let displayDate = searchQuery.displayDate

        // Then
        XCTAssertEqual(displayDate, "12. 17.")
    }

    func test_검색_쿼리_해시_가능() {
        // Given
        let date = Date()
        let query1 = SearchQuery(query: "Swift", updatedAt: date, createdAt: date)
        let query2 = SearchQuery(query: "Swift", updatedAt: date, createdAt: date)
        let query3 = SearchQuery(query: "iOS", updatedAt: date, createdAt: date)

        // Then
        XCTAssertEqual(query1, query2)
        XCTAssertNotEqual(query1, query3)
    }
}

final class GitHubRepoTests: XCTestCase {

    func test_깃허브_저장소_초기화() {
        // Given
        let title = "swift"
        let description = "The Swift Programming Language"
        let thumbnailUrl = "https://example.com/swift.png"
        let url = "https://github.com/apple/swift"

        // When
        let repo = GitHubRepo(
            title: title,
            description: description,
            thumbnailUrl: thumbnailUrl,
            url: url
        )

        // Then
        XCTAssertEqual(repo.title, title)
        XCTAssertEqual(repo.description, description)
        XCTAssertEqual(repo.thumbnailUrl, thumbnailUrl)
        XCTAssertEqual(repo.url, url)
    }

    func test_깃허브_저장소_해시_가능() {
        // Given
        let repo1 = GitHubRepo(
            title: "swift",
            description: "desc",
            thumbnailUrl: "url",
            url: "url"
        )
        let repo2 = GitHubRepo(
            title: "swift",
            description: "desc",
            thumbnailUrl: "url",
            url: "url"
        )
        let repo3 = GitHubRepo(
            title: "different",
            description: "desc",
            thumbnailUrl: "url",
            url: "url"
        )

        // Then
        XCTAssertEqual(repo1, repo2)
        XCTAssertNotEqual(repo1, repo3)
    }
}

final class GitHubRepoPageTests: XCTestCase {

    func test_깃허브_저장소_페이지_초기화() {
        // Given
        let page = 1
        let totalCount = 100
        let items = [
            GitHubRepo(
                title: "swift",
                description: "desc",
                thumbnailUrl: "url",
                url: "url"
            )
        ]

        // When
        let repoPage = GitHubRepoPage(
            page: page,
            totalCount: totalCount,
            items: items
        )

        // Then
        XCTAssertEqual(repoPage.page, page)
        XCTAssertEqual(repoPage.totalCount, totalCount)
        XCTAssertEqual(repoPage.items.count, items.count)
    }
}
