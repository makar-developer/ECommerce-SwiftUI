//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import SwiftUI
import Combine
import CoreEntities
import CoreUseCases

@MainActor
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
    private let removeEntireItemUseCase: RemoveEntireItemFromCartUseCaseProtocol
    
    // Cancellables for async operations
    private var cancellables = Set<AnyCancellable>()
    
    // Initializer
    public init(
        user: User,
        getAllProductsUseCase: GetAllProductsUseCaseProtocol,
        addProductToCartUseCase: AddProductToCartUseCaseProtocol,
        removeProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol,
        removeAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol,
        removeEntireItemUseCase: RemoveEntireItemFromCartUseCaseProtocol
    ) {
        self.user = user
        self.getAllProductsUseCase = getAllProductsUseCase
        self.addProductToCartUseCase = addProductToCartUseCase
        self.removeProductFromCartUseCase = removeProductFromCartUseCase
        self.removeAllProductsFromCartUseCase = removeAllProductsFromCartUseCase
        self.removeEntireItemUseCase = removeEntireItemUseCase
        setupTotalPriceObservation()
    }
    
    private func setupTotalPriceObservation() {
        // Observe changes and calculate total price
        $cartItems
            .map { items in
                items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
            }
            .sink(receiveValue: { [weak self] totalPrice in
                self?.totalPrice = totalPrice
            })
            .store(in: &cancellables)
    }
    
    // Load cart items
    public func loadCartItems() {
        Task {
            do {
                let items = try await getAllProductsUseCase.execute(user: user)
                self.cartItems = items
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
                self.loadCartItems()
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
                self.loadCartItems()
            } catch {
                print("Error decrementing quantity: \(error)")
            }
        }
    }
    
    public func removeEntireItem(_ cartItem: CartItem) {
        Task {
            do {
                try await removeEntireItemUseCase.execute(cartItem: cartItem, user: user)
                loadCartItems()
            } catch {
                print("Error removing entire item: \(error)")
            }
        }
    }
    
    // Checkout action
    public func checkout() {
        Task {
            do {
                try await removeAllProductsFromCartUseCase.execute(user: user)
                self.cartItems = []
                print("Total price at checkout: \(self.totalPrice)")
            } catch {
                print("Error during checkout: \(error)")
            }
        }
    }
}
