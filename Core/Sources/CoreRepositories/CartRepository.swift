//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import Foundation
import CoreData
import CoreEntities
import CoreDataSources
// MARK: - CartRepositoryProtocol

public protocol CartRepositoryProtocol {
    func getCart(for user: User) async throws -> Cart
    func addItem(_ item: CartItem, to user: User) async throws
    func updateItem(_ item: CartItem, for user: User) async throws
    func removeItem(_ item: CartItem, from user: User) async throws
}
// MARK: - CartRepositoryImpl

public final class CartRepositoryImpl: CartRepositoryProtocol {
    
    private let coreDataWrapper: CoreDataWrapperProtocol

    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }

    public func getCart(for user: User) async throws -> Cart {
        let predicate = NSPredicate(format: "userData.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataWrapper.fetch(entityName: "CartEntity", predicate: predicate)

        guard let cartEntity = fetchedCarts.first else {
            // If no cart exists, create a new one
            let newCart = Cart(products: [], id: UUID(), userId: user.id)
            let newCartEntity = newCart.toCoreData(context: coreDataWrapper.context)
            // Link to user
            let userDataEntity = try await fetchOrCreateUserDataEntity(for: user)
            newCartEntity.userData = userDataEntity
            try await coreDataWrapper.save(newCartEntity)
            return newCartEntity.toDomain()
        }
        return cartEntity.toDomain()
    }

    public func addItem(_ item: CartItem, to user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)

        // Fetch or create product entity
        let productEntity = try await fetchOrCreateProductEntity(from: item.product)
        
        // Check if the item is already in the cart
        let existingItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        if let existingCartItem = existingItems.first(where: { $0.product?.id == productEntity.id }) {
            // Update quantity
            existingCartItem.quantity += Int16(item.quantity)
            try await coreDataWrapper.save(existingCartItem)
        } else {
            // Create new cart item
            let cartItemEntity = item.toCoreData(context: coreDataWrapper.context)
            cartItemEntity.product = productEntity
            cartItemEntity.cart = cartEntity
            try await coreDataWrapper.save(cartItemEntity)
        }
    }

    public func updateItem(_ item: CartItem, for user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let existingItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        if let cartItemEntity = existingItems.first(where: { $0.id == item.id }) {
            cartItemEntity.quantity = Int16(item.quantity)
            try await coreDataWrapper.save(cartItemEntity)
        }
    }

    public func removeItem(_ item: CartItem, from user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let existingItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        if let cartItemEntity = existingItems.first(where: { $0.id == item.id }) {
            try await coreDataWrapper.delete(cartItemEntity)
        }
    }

    // MARK: - Private Helpers

    private func fetchOrCreateCartEntity(for user: User) async throws -> CartEntity {
        let predicate = NSPredicate(format: "userData.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataWrapper.fetch(entityName: "CartEntity", predicate: predicate)

        if let existingCart = fetchedCarts.first {
            return existingCart
        } else {
            let newCart = Cart(products: [], id: UUID(), userId: user.id)
            let newCartEntity = newCart.toCoreData(context: coreDataWrapper.context)
            let userDataEntity = try await fetchOrCreateUserDataEntity(for: user)
            newCartEntity.userData = userDataEntity
            try await coreDataWrapper.save(newCartEntity)
            return newCartEntity
        }
    }

    private func fetchOrCreateProductEntity(from product: Product) async throws -> ProductEntity {
        let predicate = NSPredicate(format: "id == %d", product.id)
        let fetched: [ProductEntity] = try await coreDataWrapper.fetch(entityName: "ProductEntity", predicate: predicate)
        if let existingEntity = fetched.first {
            return existingEntity
        } else {
            let entity = product.toCoreData(context: coreDataWrapper.context)
            try await coreDataWrapper.save(entity)
            return entity
        }
    }
    
    private func fetchOrCreateUserDataEntity(for user: User) async throws -> UserDataEntity {
        let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        if let userDataEntity = fetched.first {
            return userDataEntity
        } else {
            let entity = user.toCoreData(context: coreDataWrapper.context)
            try await coreDataWrapper.save(entity)
            return entity
        }
    }
}
