//
//  RemoveAllProductsFromCartUseCase.swift
//
//
//  Created by Admin on 05/12/2024.
//

import CoreEntities
import CoreRepositories

public protocol RemoveAllProductsFromCartUseCaseProtocol {
    func execute(user: User) async throws
}

public final class RemoveAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol {
    private let cartRepository: CartRepositoryProtocol

    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }

    public func execute(user: User) async throws {
        let cart = try await cartRepository.getCart(for: user)
        for item in cart.products {
            try await cartRepository.removeItem(item, from: user)
        }
    }
}
