//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreUseCases
@testable import CoreTestHelpers

final class AddProductToCartUseCaseTests: XCTestCase {
    
    private var mockRepo: MockCartRepository!
    private var sut: AddProductToCartUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockCartRepository()
        sut = AddProductToCartUseCase(cartRepository: mockRepo)
    }
    
    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }
    
    func testExecute_AddsNewItemWhenNotPresent() async throws {
        // given
        let user = User.getOneOfThis()
        let product = Product.getOneOfThis()
        
        // when
        try await sut.execute(product: product, user: user)
        
        // then
        XCTAssertTrue(mockRepo.didGetCart, "Expected getCart to be called.")
        XCTAssertTrue(mockRepo.didAddItem, "Expected addItem to be called.")
        
        let resultingCart = try await mockRepo.getCart(for: user)
        XCTAssertEqual(resultingCart.products.count, 1, "Cart should have exactly 1 product after adding.")
        XCTAssertEqual(resultingCart.products.first?.quantity, 1, "The added item should have quantity 1.")
    }
    
    func testExecute_IncrementsQuantityWhenAlreadyInCart() async throws {
        // given
        let user = User.getOneOfThis()
        let product = Product.getOneOfThis() // same product to check increment
        try await mockRepo.addItem(CartItem(product: product, quantity: 1), to: user)
        
        // when
        try await sut.execute(product: product, user: user)
        
        // then
        let resultingCart = try await mockRepo.getCart(for: user)
        XCTAssertEqual(resultingCart.products.count, 1, "Still only one product total.")
        XCTAssertEqual(resultingCart.products.first?.quantity, 2, "Quantity should now be 2 after second addition.")
    }
}
