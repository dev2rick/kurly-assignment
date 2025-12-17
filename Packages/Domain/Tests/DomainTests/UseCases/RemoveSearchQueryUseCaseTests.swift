//
//  RemoveSearchQueryUseCaseTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class RemoveSearchQueryUseCaseTests: XCTestCase {
    var sut: DefaultRemoveSearchQueryUseCase!
    var mockRepository: MockSearchQueryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchQueryRepository()
        sut = DefaultRemoveSearchQueryUseCase(searchQueryRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_검색_쿼리_삭제_성공() async throws {
        // Given
        let searchQuery = "Swift"

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.removeCallCount, 1)
        XCTAssertEqual(mockRepository.removeLastQuery, searchQuery)
    }

    func test_검색_쿼리_삭제_다양한_쿼리() async throws {
        // Given
        let queries = ["Swift", "iOS", "SwiftUI", "UIKit"]

        // When
        for query in queries {
            try await sut.execute(searchQuery: query)
        }

        // Then
        XCTAssertEqual(mockRepository.removeCallCount, queries.count)
        XCTAssertEqual(mockRepository.removeLastQuery, queries.last)
    }

    func test_검색_쿼리_삭제_빈_문자열() async throws {
        // Given
        let searchQuery = ""

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.removeCallCount, 1)
        XCTAssertEqual(mockRepository.removeLastQuery, searchQuery)
    }

    func test_검색_쿼리_삭제_특수문자_포함() async throws {
        // Given
        let searchQuery = "Swift+iOS 개발"

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.removeCallCount, 1)
        XCTAssertEqual(mockRepository.removeLastQuery, searchQuery)
    }

    func test_검색_쿼리_삭제_다중_호출() async throws {
        // Given
        let searchQuery = "Swift"
        let repeatCount = 3

        // When
        for _ in 0..<repeatCount {
            try await sut.execute(searchQuery: searchQuery)
        }

        // Then
        XCTAssertEqual(mockRepository.removeCallCount, repeatCount)
    }

    // MARK: - Failure Cases

    func test_검색_쿼리_삭제_실패() async throws {
        // Given
        let searchQuery = "Swift"
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.removeResult = expectedError

        // When/Then
        do {
            try await sut.execute(searchQuery: searchQuery)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.removeCallCount, 1)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
