//
//  GetAllProductsUseCase.swift
//
//
//  Created by Admin on 05/12/2024.
//

import CoreEntities
import CoreRepositories

public protocol GetAllProductsUseCaseProtocol {
    func execute(user: User) async throws -> [CartItem]
}

public final class GetAllProductsUseCase: GetAllProductsUseCaseProtocol {
    private let cartRepository: CartRepositoryProtocol

    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }

    public func execute(user: User) async throws -> [CartItem] {
        let cart = try await cartRepository.getCart(for: user)
        return cart.products
    }
}
