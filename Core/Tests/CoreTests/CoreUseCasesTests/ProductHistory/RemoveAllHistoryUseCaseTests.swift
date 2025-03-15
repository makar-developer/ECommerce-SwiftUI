//
//  File 4.swift
//
//
//  Created by Admin on 12/01/2025.
//
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class RemoveAllHistoryUseCaseTests: XCTestCase {
    private var sut: RemoveAllHistoryUseCase!
    private var mockRepository: MockProductHistoryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductHistoryRepository()
        sut = RemoveAllHistoryUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ShouldCallRemoveAllHistoryOnRepository() async throws {
        // given
        let user = User.getOneOfThis()

        // when
        try await sut.execute(for: user.id)

        // then
        XCTAssertEqual(mockRepository.removeAllHistoryCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUserId, user.id)
    }
}
