//
//  SaveSearchQueryUseCaseTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class SaveSearchQueryUseCaseTests: XCTestCase {
    var sut: DefaultSaveSearchQueryUseCase!
    var mockRepository: MockSearchQueryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchQueryRepository()
        sut = DefaultSaveSearchQueryUseCase(searchQueryRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_검색_쿼리_저장_성공() async throws {
        // Given
        let searchQuery = "Swift"

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.saveCallCount, 1)
        XCTAssertEqual(mockRepository.saveLastQuery, searchQuery)
    }

    func test_검색_쿼리_저장_빈_문자열() async throws {
        // Given
        let searchQuery = ""

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.saveCallCount, 1)
        XCTAssertEqual(mockRepository.saveLastQuery, searchQuery)
    }

    func test_검색_쿼리_저장_특수문자_포함() async throws {
        // Given
        let searchQuery = "Swift+iOS 개발"

        // When
        try await sut.execute(searchQuery: searchQuery)

        // Then
        XCTAssertEqual(mockRepository.saveCallCount, 1)
        XCTAssertEqual(mockRepository.saveLastQuery, searchQuery)
    }

    func test_검색_쿼리_저장_다중_호출() async throws {
        // Given
        let queries = ["Swift", "iOS", "SwiftUI"]

        // When
        for query in queries {
            try await sut.execute(searchQuery: query)
        }

        // Then
        XCTAssertEqual(mockRepository.saveCallCount, queries.count)
        XCTAssertEqual(mockRepository.saveLastQuery, queries.last)
    }

    // MARK: - Failure Cases

    func test_검색_쿼리_저장_실패() async throws {
        // Given
        let searchQuery = "Swift"
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.saveResult = expectedError

        // When/Then
        do {
            try await sut.execute(searchQuery: searchQuery)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.saveCallCount, 1)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
