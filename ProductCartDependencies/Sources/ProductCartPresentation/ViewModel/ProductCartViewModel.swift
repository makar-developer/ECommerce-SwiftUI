//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import CoreEntities
import CoreUseCases
import SwiftUI
import Combine

public class ProductCartViewModel: ObservableObject {
    // Published properties
    @Published public var cartItems: [CartItem] = []
    @Published public var totalPrice: Double = 0.0
    
    // Dependencies
    private let user: User
    private let getAllProductsUseCase: GetAllProductsUseCaseProtocol
    private let addProductToCartUseCase: AddProductToCartUseCaseProtocol
    private let removeProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol
    private let removeAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol
    
    // Cancellables for async operations
    private var cancellables = Set<AnyCancellable>()
    
    // Initializer
    public init(
        user: User,
        getAllProductsUseCase: GetAllProductsUseCaseProtocol,
        addProductToCartUseCase: AddProductToCartUseCaseProtocol,
        removeProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol,
        removeAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol
    ) {
        self.user = user
        self.getAllProductsUseCase = getAllProductsUseCase
        self.addProductToCartUseCase = addProductToCartUseCase
        self.removeProductFromCartUseCase = removeProductFromCartUseCase
        self.removeAllProductsFromCartUseCase = removeAllProductsFromCartUseCase
        setupTotalPriceObservation()
    }
    
    private func setupTotalPriceObservation() {
        // Observe changes and calculate total price
        $cartItems
            .map { items in
                items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
            }
            .assign(to: \.totalPrice, on: self)
            .store(in: &cancellables)
    }
    
    // Load cart items
    public func loadCartItems() {
        Task {
            do {
                let items = try await getAllProductsUseCase.execute(user: user)
                await MainActor.run {
                    self.cartItems = items
                }
            } catch {
                print("Error loading cart items: \(error)")
            }
        }
    }
    
    // Increment product quantity
    public func incrementQuantity(for cartItem: CartItem) {
        Task {
            do {
                try await addProductToCartUseCase.execute(product: cartItem.product, user: user)
                await MainActor.run {
                    self.loadCartItems()
                }
            } catch {
                print("Error incrementing quantity: \(error)")
            }
        }
    }
    
    // Decrement product quantity
    public func decrementQuantity(for cartItem: CartItem) {
        Task {
            do {
                try await removeProductFromCartUseCase.execute(cartItem: cartItem, user: user)
                await MainActor.run {
                    self.loadCartItems()
                }
            } catch {
                print("Error decrementing quantity: \(error)")
            }
        }
    }
    
    // Remove specific item
    public func removeItem(_ cartItem: CartItem) {
        Task {
            do {
                try await removeProductFromCartUseCase.execute(cartItem: cartItem, user: user)
                await MainActor.run {
                    self.loadCartItems()
                }
            } catch {
                print("Error removing item: \(error)")
            }
        }
    }
    
    // Checkout action
    public func checkout() {
        Task {
            do {
                try await removeAllProductsFromCartUseCase.execute(user: user)
                await MainActor.run {
                    self.cartItems = []
                    print("Total price at checkout: \(self.totalPrice)")
                }
            } catch {
                print("Error during checkout: \(error)")
            }
        }
    }
}
