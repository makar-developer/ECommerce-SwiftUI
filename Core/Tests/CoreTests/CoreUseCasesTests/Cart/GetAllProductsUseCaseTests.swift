//
//  GetAllProductsUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class GetAllProductsUseCaseTests: XCTestCase {
    private var mockRepo: MockCartRepository!
    private var sut: GetAllProductsUseCase!

    override func setUp() {
        super.setUp()
        mockRepo = MockCartRepository()
        sut = GetAllProductsUseCase(cartRepository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testExecute_ReturnsAllCartItems() async throws {
        // given
        let user = User.getOneOfThis()
        let items = CartItem.getAnArrayOfThese() // adds 3 items
        for item in items {
            try await mockRepo.addItem(item, to: user)
        }

        // when
        let result = try await sut.execute(user: user)

        // then
        XCTAssertTrue(mockRepo.didGetCart, "Expected getCart to be called.")
        XCTAssertEqual(result.count, 3, "Should retrieve all items in the cart.")
    }
}
