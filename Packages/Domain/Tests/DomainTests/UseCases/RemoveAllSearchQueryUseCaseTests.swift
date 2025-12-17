//
//  RemoveAllSearchQueryUseCaseTests.swift
//  DomainTests
//
//  Created by Claude on 12/17/25.
//

import XCTest
@testable import Domain

final class RemoveAllSearchQueryUseCaseTests: XCTestCase {
    var sut: DefaultRemoveAllSearchQueryUseCase!
    var mockRepository: MockSearchQueryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchQueryRepository()
        sut = DefaultRemoveAllSearchQueryUseCase(searchQueryRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_전체_검색_쿼리_삭제_성공() async throws {
        // Given
        // No specific setup needed

        // When
        try await sut.execute()

        // Then
        XCTAssertEqual(mockRepository.removeAllCallCount, 1)
    }

    func test_전체_검색_쿼리_삭제_다중_호출() async throws {
        // Given
        let executeCount = 3

        // When
        for _ in 0..<executeCount {
            try await sut.execute()
        }

        // Then
        XCTAssertEqual(mockRepository.removeAllCallCount, executeCount)
    }

    func test_전체_검색_쿼리_삭제_저장_후() async throws {
        // Given
        // Simulate that some queries were saved
        mockRepository.saveCallCount = 5

        // When
        try await sut.execute()

        // Then
        XCTAssertEqual(mockRepository.removeAllCallCount, 1)
    }

    func test_전체_검색_쿼리_삭제_멱등성() async throws {
        // Given
        // Execute twice

        // When
        try await sut.execute()
        try await sut.execute()

        // Then
        // Should be called twice successfully
        XCTAssertEqual(mockRepository.removeAllCallCount, 2)
    }

    // MARK: - Failure Cases

    func test_전체_검색_쿼리_삭제_실패() async throws {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.removeAllResult = expectedError

        // When/Then
        do {
            try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.removeAllCallCount, 1)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }

    func test_전체_검색_쿼리_삭제_데이터베이스_에러() async throws {
        // Given
        let databaseError = NSError(
            domain: "DatabaseError",
            code: 1001,
            userInfo: [NSLocalizedDescriptionKey: "Database connection failed"]
        )
        mockRepository.removeAllResult = databaseError

        // When/Then
        do {
            try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(mockRepository.removeAllCallCount, 1)
            XCTAssertEqual(error.domain, "DatabaseError")
            XCTAssertEqual(error.code, 1001)
        }
    }
}
