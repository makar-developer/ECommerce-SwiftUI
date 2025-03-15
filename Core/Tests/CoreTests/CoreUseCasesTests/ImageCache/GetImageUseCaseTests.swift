//
//  GetImageUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreRepositories
@testable import CoreUseCases
import UIKit
import XCTest

final class GetImageUseCaseTests: XCTestCase {
    private var mockRepository: MockImageRepository!
    private var sut: GetImageUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockImageRepository()
        sut = GetImageUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_SuccessfulFetch_ReturnsImage() async throws {
        // given
        let testImage = UIImage.getOneOfThis()
        mockRepository.imageToReturn = testImage

        let testURL = URL.getOneOfThis()

        // when
        let resultImage = try await sut.execute(url: testURL)

        // then
        XCTAssertEqual(resultImage, testImage, "Expected the image returned by the mock repository to match the test image.")
    }

    func testExecute_Failure_ThrowsError() async {
        // given
        // Simulate a network or decoding error
        mockRepository.errorToThrow = URLError(.timedOut)
        let testURL = URL.getOneOfThis()

        // when
        do {
            _ = try await sut.execute(url: testURL)
            XCTFail("Expected an error to be thrown, but got success.")
        } catch {
            // then
            XCTAssertTrue(error is URLError, "Should throw URLError as injected by the mock repository.")
        }
    }

    func testExecute_NoExplicitConfig_ReturnsPlaceholder() async throws {
        // given
        let testURL = URL.getOneOfThis()

        // when
        let resultImage = try await sut.execute(url: testURL)

        // then
        XCTAssertNotNil(resultImage, "Should return some non-nil UIImage placeholder by default.")
        XCTAssertNil(mockRepository.errorToThrow, "No error was configured, so none should be thrown.")
    }
}
