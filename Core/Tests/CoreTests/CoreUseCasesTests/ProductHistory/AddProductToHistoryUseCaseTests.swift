//
//  File 2.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class AddProductToHistoryUseCaseTests: XCTestCase {
    private var sut: AddProductToHistoryUseCase!
    private var mockRepository: MockProductHistoryRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductHistoryRepository()
        sut = AddProductToHistoryUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ShouldCallAddProductToHistoryOnRepository() async throws {
        // given
        let product = Product.getOneOfThis()
        let user = User.getOneOfThis()

        // when
        try await sut.execute(product: product, for: user.id)

        // then
        XCTAssertEqual(mockRepository.addProductToHistoryCallCount, 1)
        XCTAssertEqual(mockRepository.capturedProduct, product)
        XCTAssertEqual(mockRepository.capturedUserId, user.id)
    }
}
