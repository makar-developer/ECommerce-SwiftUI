//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//


import CoreEntities
import CoreRepositories
public protocol AddProductToCartUseCaseProtocol {
    func execute(product: Product, user: User) async throws
}

public final class AddProductToCartUseCase: AddProductToCartUseCaseProtocol {
    
    private let cartRepository: CartRepositoryProtocol
    
    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }
    
    public func execute(product: Product, user: User) async throws {
        // Fetch current cart
        let cart = try await cartRepository.getCart(for: user)
        
        // Check if product already exists in cart
        if let existingItem = cart.products.first(where: { $0.product.id == product.id }) {
            var updatedItem = existingItem
            updatedItem.quantity += 2
            try await cartRepository.updateItem(updatedItem, for: user)
        } else {
            // Add new item
            let newItem = CartItem(product: product, quantity: 1)
            try await cartRepository.addItem(newItem, to: user)
        }
    }
}

public final class MockAddProductToCartUseCase: AddProductToCartUseCaseProtocol {
    
    // Track the number of times 'execute' is called
    private(set) var executeCallCount = 0
    
    // Track parameters for verification
    private(set) var passedProduct: Product?
    private(set) var passedUser: User?
    
    // Optional error to simulate failure
    var errorToThrow: Error?
    
    public init() {} // No dependencies
    
    public func execute(product: Product, user: User) async throws {
        executeCallCount += 1
        passedProduct = product
        passedUser = user
        
        if let error = errorToThrow {
            throw error
        }
    }
}
