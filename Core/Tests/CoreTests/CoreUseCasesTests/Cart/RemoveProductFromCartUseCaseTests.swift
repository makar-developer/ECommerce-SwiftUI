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

final class RemoveProductFromCartUseCaseTests: XCTestCase {
    private var mockRepo: MockCartRepository!
    private var sut: RemoveProductFromCartUseCase!

    override func setUp() {
        super.setUp()
        mockRepo = MockCartRepository()
        sut = RemoveProductFromCartUseCase(cartRepository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testExecute_DecrementsQuantityIfMoreThanOne() async throws {
        // given
        let user = User.getOneOfThis()
        var item = CartItem.getOneOfThis()
        item.quantity = 3 // ensure it's more than 1
        try await mockRepo.addItem(item, to: user)

        // when
        try await sut.execute(cartItem: item, user: user)

        // then
        XCTAssertTrue(mockRepo.didUpdateItem, "Expected updateItem when quantity > 1.")
        let updatedCart = try await mockRepo.getCart(for: user)
        XCTAssertEqual(updatedCart.products.first?.quantity, 2, "Quantity should have gone from 3 to 2.")
    }

    func testExecute_RemovesItemIfLastQuantity() async throws {
        // given
        let user = User.getOneOfThis()
        var item = CartItem.getOneOfThis()
        item.quantity = 1 // ensure it's the last quantity
        try await mockRepo.addItem(item, to: user)

        // when
        try await sut.execute(cartItem: item, user: user)

        // then
        XCTAssertTrue(mockRepo.didRemoveItem, "Expected removeItem when quantity <= 1.")
        let updatedCart = try await mockRepo.getCart(for: user)
        XCTAssertTrue(updatedCart.products.isEmpty, "Item with quantity 1 should be removed entirely.")
    }
}
