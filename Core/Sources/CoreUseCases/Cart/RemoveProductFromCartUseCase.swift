//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import CoreEntities
import CoreRepositories

public protocol RemoveProductFromCartUseCaseProtocol {
    func execute(cartItem: CartItem, user: User) async throws
}

public class RemoveProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol {
    
    private let cartRepository: CartRepositoryProtocol
    
    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }
    
    public func execute(cartItem: CartItem, user: User) async throws {
        if cartItem.quantity <= 1 {
            try await cartRepository.removeItem(cartItem, from: user)
        } else {
            var updatedItem = cartItem
            updatedItem.quantity -= 1
            try await cartRepository.updateItem(updatedItem, for: user)
        }
    }
}
