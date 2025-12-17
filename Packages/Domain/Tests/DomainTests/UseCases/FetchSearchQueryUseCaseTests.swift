//
//  FetchSearchQueryUseCaseTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class FetchSearchQueryUseCaseTests: XCTestCase {
    var sut: DefaultFetchSearchQueryUseCase!
    var mockRepository: MockSearchQueryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchQueryRepository()
        sut = DefaultFetchSearchQueryUseCase(searchQueryRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_검색_쿼리_목록_조회_성공() async throws {
        // Given
        let query: String? = nil
        let limit = 10
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date()),
            SearchQuery(query: "iOS", updatedAt: Date(), createdAt: Date()),
            SearchQuery(query: "SwiftUI", updatedAt: Date(), createdAt: Date())
        ]
        mockRepository.fetchAllResult = .success(expectedQueries)

        // When
        let result = try await sut.execute(query: query, limit: limit)

        // Then
        XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
        XCTAssertNil(mockRepository.fetchAllLastQuery)
        XCTAssertEqual(mockRepository.fetchAllLastLimit, limit)
        XCTAssertEqual(result.count, expectedQueries.count)
        XCTAssertEqual(result[0].query, "Swift")
        XCTAssertEqual(result[1].query, "iOS")
        XCTAssertEqual(result[2].query, "SwiftUI")
    }

    func test_검색_쿼리_목록_조회_쿼리_필터링() async throws {
        // Given
        let query = "Swift"
        let limit = 5
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: Date(), createdAt: Date()),
            SearchQuery(query: "SwiftUI", updatedAt: Date(), createdAt: Date())
        ]
        mockRepository.fetchAllResult = .success(expectedQueries)

        // When
        let result = try await sut.execute(query: query, limit: limit)

        // Then
        XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
        XCTAssertEqual(mockRepository.fetchAllLastQuery, query)
        XCTAssertEqual(mockRepository.fetchAllLastLimit, limit)
        XCTAssertEqual(result.count, expectedQueries.count)
    }

    func test_검색_쿼리_목록_조회_빈_결과() async throws {
        // Given
        let query: String? = nil
        let limit = 10
        mockRepository.fetchAllResult = .success([])

        // When
        let result = try await sut.execute(query: query, limit: limit)

        // Then
        XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
        XCTAssertTrue(result.isEmpty)
    }

    func test_검색_쿼리_목록_조회_다양한_개수_제한() async throws {
        // Given
        let limits = [5, 10, 20]
        let expectedQueries = (0..<20).map {
            SearchQuery(query: "Query \($0)", updatedAt: Date(), createdAt: Date())
        }
        mockRepository.fetchAllResult = .success(expectedQueries)

        // When/Then
        for limit in limits {
            _ = try await sut.execute(query: nil, limit: limit)
            XCTAssertEqual(mockRepository.fetchAllLastLimit, limit)
        }
    }

    func test_검색_쿼리_목록_조회_날짜_정보_보존() async throws {
        // Given
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let expectedQueries = [
            SearchQuery(query: "Swift", updatedAt: now, createdAt: yesterday),
            SearchQuery(query: "iOS", updatedAt: yesterday, createdAt: yesterday)
        ]
        mockRepository.fetchAllResult = .success(expectedQueries)

        // When
        let result = try await sut.execute(query: nil, limit: 10)

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].updatedAt.timeIntervalSince1970, now.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(result[1].updatedAt.timeIntervalSince1970, yesterday.timeIntervalSince1970, accuracy: 1.0)
    }

    // MARK: - Failure Cases

    func test_검색_쿼리_목록_조회_실패() async throws {
        // Given
        let query: String? = nil
        let limit = 10
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.fetchAllResult = .failure(expectedError)

        // When/Then
        do {
            _ = try await sut.execute(query: query, limit: limit)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.fetchAllCallCount, 1)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
