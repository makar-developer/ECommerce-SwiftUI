//
//  ProductDetailsViewModel.swift
//
//
//  Created by Admin on 03/12/2024.
//

import CoreEntities
import CoreUseCases
import Foundation

public final class ProductDetailsViewModel: ObservableObject {
    @Published private(set) var user: User
    @Published private(set) var product: Product
    @Published var currentImageIndex: Int = 0
    let onNavigation: () -> Void

    private let addProductToCartUseCase: AddProductToCartUseCaseProtocol
    private let addProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol

    let getImageUseCase: GetImageUseCaseProtocol

    public init(
        user: User,
        product: Product,
        addProductToCartUseCase: AddProductToCartUseCaseProtocol,
        addProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol,
        getImageUseCase: GetImageUseCaseProtocol,
        onNavigation: @escaping () -> Void
    ) {
        self.user = user
        self.product = product
        self.addProductToCartUseCase = addProductToCartUseCase
        self.addProductToHistoryUseCase = addProductToHistoryUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation
    }

    public func addToCart() {
        Task {
            do {
                try await addProductToCartUseCase.execute(product: product, user: user)
            } catch {
                print("Failed to add product to cart: \(error)")
            }
        }
    }

    public func addProductToHistory() async {
        do {
            try await addProductToHistoryUseCase.execute(product: product, for: user.id)
        } catch {
            print("Failed to add product to history \(error)")
        }
    }
}
