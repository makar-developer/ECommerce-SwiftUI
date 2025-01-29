//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreDataSources
@testable import CoreRepositories
@testable import CoreTestHelpers

final class CartRepositoryTests: XCTestCase {
    
    private var sut: CartRepositoryImpl!            // The real object under test
    private var mockCoreDataDataSource: MockCoreDataDataSource!  // Our mock data source
    
    override func setUp() {
        super.setUp()
        // Initialize the mock with the model name that corresponds to your .xcdatamodeld file,
        // e.g. "UserData" or "MyModel"—whatever the actual name is.
        mockCoreDataDataSource = MockCoreDataDataSource(modelName: "UserData")
        sut = CartRepositoryImpl(coreDataDataSource: mockCoreDataDataSource)
    }
    
    override func tearDown() {
        sut = nil
        mockCoreDataDataSource = nil
        super.tearDown()
    }
    
    // MARK: - getCart(for:) Tests
    
    func test_getCart_whenNoExistingCart_createsNewCart() async throws {
        // given
        let user = User.getOneOfThis()  // This user has no cart in the store
        
        // when
        let cart = try await sut.getCart(for: user)
        
        // then
        XCTAssertEqual(cart.userId, user.id, "A new cart should be created for the user.")
        XCTAssertTrue(cart.products.isEmpty, "Newly created carts should have no products by default.")
    }
    
    func test_getCart_whenCartAlreadyExists_returnsExistingCart() async throws {
        // given
        let user = User.getOneOfThis()
        // Pre-create a CartEntity in memory with the same user ID
        _ = try await createCartEntityInMemory(for: user)
        
        // when
        let fetchedCart = try await sut.getCart(for: user)
        
        // then
        // The repository should fetch the pre-existing cart, not create a new one.
        XCTAssertEqual(fetchedCart.userId, user.id)
        XCTAssertEqual(fetchedCart.products.count, 0, "Pre-created cart was empty.")
    }
    
    // MARK: - addItem(_:to:) Tests
    
    func test_addItem_whenItemDoesNotExist_createsNewItemInCart() async throws {
        // given
        let user = User.getOneOfThis()
        // Ensure the user has an empty cart
        _ = try await sut.getCart(for: user)
        
        let newItem = CartItem.getOneOfThis()  // e.g. a product with some quantity
        
        // when
        try await sut.addItem(newItem, to: user)
        
        // then
        // The repository should have a cart with 1 item.
        let updatedCart = try await sut.getCart(for: user)
        XCTAssertEqual(updatedCart.products.count, 1, "Cart should have exactly one item.")
        XCTAssertEqual(updatedCart.products.first?.product.id, newItem.product.id)
    }
    
    func test_addItem_whenItemAlreadyInCart_incrementsQuantity() async throws {
        // given
        let user = User.getOneOfThis()
        // Create the cart
        _ = try await sut.getCart(for: user)
        
        // Add the same item once
        let item = CartItem.getOneOfThis()
        try await sut.addItem(item, to: user)
        
        // when
        // Add the same item again
        try await sut.addItem(item, to: user)
        
        // then
        // The quantity should have increased
        let cart = try await sut.getCart(for: user)
        XCTAssertEqual(cart.products.count, 1, "Only one item record should exist.")
        XCTAssertEqual(cart.products.first?.quantity, item.quantity * 2, "Quantity should have doubled.")
    }
    
    // MARK: - updateItem(_:for:) Tests
    
    func test_updateItem_whenItemExists_updatesQuantity() async throws {
        // given
        let user = User.getOneOfThis()
        // Create the cart
        _ = try await sut.getCart(for: user)
        
        // Add an item
        var item = CartItem.getOneOfThis()
        item.quantity = 2
        try await sut.addItem(item, to: user)
        
        // when
        // We want to update the quantity from 2 -> 5
        let updatedItem = CartItem(product: item.product, quantity: 5, id: item.id)
        try await sut.updateItem(updatedItem, for: user)
        
        // then
        // Confirm the quantity changed
        let cart = try await sut.getCart(for: user)
        XCTAssertEqual(cart.products.first?.quantity, 5, "Quantity should be updated to 5.")
    }
    
    // MARK: - Helper for Tests
    
    /// Optionally: a small helper to manually create a CartEntity in memory, which can be used to simulate a pre-existing cart for a user.
    private func createCartEntityInMemory(for user: User) async throws -> CartEntity {
        let cart = Cart(products: [], userId: user.id)
        let cartEntity = cart.toCoreData(context: mockCoreDataDataSource.context)
        // Link the cart entity to the existing or newly created userData
        let userData = try await fetchOrCreateUserData(for: user)
        cartEntity.userData = userData
        
        try await mockCoreDataDataSource.save(cartEntity)
        return cartEntity
    }
    
    /// Manually replicate what the repository does to get or create a UserDataEntity
    private func fetchOrCreateUserData(for user: User) async throws -> UserDataEntity {
        let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let fetched: [UserDataEntity] = try await mockCoreDataDataSource.fetch(entityName: "UserDataEntity", predicate: predicate)
        if let existing = fetched.first {
            return existing
        } else {
            let entity = user.toCoreData(context: mockCoreDataDataSource.context)
            try await mockCoreDataDataSource.save(entity)
            return entity
        }
    }
}
