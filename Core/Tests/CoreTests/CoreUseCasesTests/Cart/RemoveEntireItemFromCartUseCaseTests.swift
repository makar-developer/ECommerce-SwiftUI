//
//  RemoveEntireItemFromCartUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class RemoveEntireItemFromCartUseCaseTests: XCTestCase {
    private var mockRepo: MockCartRepository!
    private var sut: RemoveEntireItemFromCartUseCase!

    override func setUp() {
        super.setUp()
        mockRepo = MockCartRepository()
        sut = RemoveEntireItemFromCartUseCase(cartRepository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testExecute_RemovesDesignatedCartItem() async throws {
        // given
        let user = User.getOneOfThis()
        let itemToRemove = CartItem.getOneOfThis()
        try await mockRepo.addItem(itemToRemove, to: user)

        // when
        try await sut.execute(cartItem: itemToRemove, user: user)

        // then
        XCTAssertTrue(mockRepo.didRemoveItem, "Expected removeItem to be called.")
        let cartAfter = try await mockRepo.getCart(for: user)
        XCTAssertFalse(cartAfter.products.contains(itemToRemove), "Removed item should be gone.")
    }
}
