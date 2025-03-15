//
//  RemoveProductFromHistoryUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class RemoveProductFromHistoryUseCaseTests: XCTestCase {
    private var sut: RemoveProductFromHistoryUseCase!
    private var mockRepository: MockProductHistoryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductHistoryRepository()
        sut = RemoveProductFromHistoryUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ShouldCallRemoveProductHistoryOnRepository() async throws {
        // given
        let user = User.getOneOfThis()
        let product = Product.getOneOfThis()

        // when
        try await sut.execute(product: product, for: user.id)

        // then
        XCTAssertEqual(mockRepository.removeProductHistoryCallCount, 1)
        XCTAssertEqual(mockRepository.capturedProduct, product)
        XCTAssertEqual(mockRepository.capturedUserId, user.id)
    }
}
