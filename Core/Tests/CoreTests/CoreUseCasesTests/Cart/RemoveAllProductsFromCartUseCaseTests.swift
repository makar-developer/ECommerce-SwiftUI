//
//  RemoveAllProductsFromCartUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class RemoveAllProductsFromCartUseCaseTests: XCTestCase {
    private var mockRepo: MockCartRepository!
    private var sut: RemoveAllProductsFromCartUseCase!

    override func setUp() {
        super.setUp()
        mockRepo = MockCartRepository()
        sut = RemoveAllProductsFromCartUseCase(cartRepository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testExecute_RemovesAllItems() async throws {
        // given
        let user = User.getOneOfThis()
        let items = CartItem.getAnArrayOfThese()
        for item in items {
            try await mockRepo.addItem(item, to: user)
        }

        // when
        try await sut.execute(user: user)

        // then
        XCTAssertTrue(mockRepo.didGetCart, "Expected getCart to be called.")
        XCTAssertTrue(mockRepo.didRemoveItem, "Expected removeItem to be called.")

        let cartAfter = try await mockRepo.getCart(for: user)
        XCTAssertEqual(cartAfter.products.count, 0, "All items should be removed from the cart.")
    }
}
