//
//  RemoveEntireItemFromCartUseCase.swift
//
//
//  Created by Admin on 04/01/2025.
//

import CoreEntities
import CoreRepositories

public protocol RemoveEntireItemFromCartUseCaseProtocol {
    func execute(cartItem: CartItem, user: User) async throws
}

public final class RemoveEntireItemFromCartUseCase: RemoveEntireItemFromCartUseCaseProtocol {
    private let cartRepository: CartRepositoryProtocol

    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }

    public func execute(cartItem: CartItem, user: User) async throws {
        // remove the entire item from the cart
        try await cartRepository.removeItem(cartItem, from: user)
    }
}
