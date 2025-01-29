//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreUseCases
@testable import CoreTestHelpers
@testable import CoreStyleguide

@MainActor
final class CustomAsyncImageViewModelTests: XCTestCase {

    func testLoad_WhenUseCaseSucceeds_ShouldSetUIImageAndNotRetry() async throws {
        // given
        let mockUseCase = MockGetImageUseCase()
        let expectedImage = UIImage.getOneOfThis() ?? UIImage()
        mockUseCase.imageToReturn = expectedImage
        let testURL = URL.getOneOfThis()

        let sut = CustomAsyncImageViewModel(url: testURL, getImageUseCase: mockUseCase)

        // when
        sut.load()
        // Allow some time for async tasks to complete
        try await Task.sleep(nanoseconds: 300_000_000)

        // then
        XCTAssertFalse(sut.isLoading, "isLoading should be false after success")
        XCTAssertEqual(sut.uiImage, expectedImage, "ViewModel’s image should match the mocked image")
        XCTAssertEqual(mockUseCase.executeCallCount, 1, "Should only call execute once on success")
    }

    func testLoad_WhenUseCaseThrowsError_ShouldRetryUpToMaxRetries() async throws {
        // given
        let mockUseCase = MockGetImageUseCase()
        // Force the use case to throw an error
        mockUseCase.errorToThrow = NSError(domain: "TestError", code: 123, userInfo: nil)
        
        let testURL = URL.getOneOfThis()
        let sut = CustomAsyncImageViewModel(url: testURL, getImageUseCase: mockUseCase)

        // when
        sut.load()
        // Wait long enough for all potential retries
        try await Task.sleep(nanoseconds: 7_000_000_000) // 2 seconds * 3 retries = up to 6s, with a small buffer

        // then
        XCTAssertFalse(sut.isLoading, "isLoading should eventually be false even after failures")
        XCTAssertNil(sut.uiImage, "uiImage should remain nil if all retries fail")
        XCTAssertEqual(mockUseCase.executeCallCount, 3, "Should attempt exactly 3 retries (maxRetries)")
    }
}
