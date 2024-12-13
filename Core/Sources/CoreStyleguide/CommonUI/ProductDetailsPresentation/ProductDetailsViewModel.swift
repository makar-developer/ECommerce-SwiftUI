//
//  File.swift
//  
//
//  Created by Admin on 03/12/2024.
//

import Foundation
import CoreEntities
import CoreUseCases
public class ProductDetailsViewModel: ObservableObject {
    @Published var user: User
    @Published var product: Product
    @Published var currentImageIndex: Int = 0  // For the carousel
    let onNavigation: () -> Void
    private let addProductToCartUseCase: AddProductToCartUseCaseProtocol
    
    public init(user: User, product: Product, addProductToCartUseCase: AddProductToCartUseCaseProtocol, onNavigation: @escaping () -> Void) {
        self.user = user
        self.product = product
        self.addProductToCartUseCase = addProductToCartUseCase
        self.onNavigation = onNavigation
    }
    
    public func addToCart() {
        Task {
            do {
                try await addProductToCartUseCase.execute(product: product, user: user)
                print("\(product.title) added to cart for \(user.id.description.prefix(6))")
            } catch {
                print("Failed to add product to cart: \(error)")
            }
        }
    }
}
	
