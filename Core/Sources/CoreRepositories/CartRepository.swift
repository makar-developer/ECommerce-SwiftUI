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

public class CartRepositoryImpl: CartRepositoryProtocol {
    
    private let coreDataWrapper: CoreDataWrapperProtocol
    
    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }
    
    public func getCart(for user: User) async throws -> Cart {
        let predicate = NSPredicate(format: "user.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataWrapper.fetch(entityName: "CartEntity", predicate: predicate)
        
        guard let cartEntity = fetchedCarts.first else {
            // If no cart exists, create a new one
            let newCartEntity = CartEntity(context: coreDataWrapper.context)
            newCartEntity.id = UUID()
            newCartEntity.user = user.toUserEntity(context: coreDataWrapper.context)
            try await coreDataWrapper.save(newCartEntity)
            return newCartEntity.toCart()
        }
        return cartEntity.toCart()
    }
    
    public func addItem(_ item: CartItem, to user: User) async throws {
        
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let productEntity = try await fetchProductEntity(from: item.product)
        
        // Check if the CartItem already exists
        if let existingCartItem = cartEntity.products?.allObjects as? [CartItemEntity],
           let cartItem = existingCartItem.first(where: { $0.product!.id == item.product.id }) {
            // Update quantity
            cartItem.quantity += Int16(item.quantity)
            try await coreDataWrapper.update(cartItem)
        } else {
            // Create new CartItem
            let cartItemEntity = CartItemEntity(context: coreDataWrapper.context)
            cartItemEntity.id = item.id
            cartItemEntity.quantity = Int16(item.quantity)
            cartItemEntity.product = productEntity
            cartItemEntity.cart = cartEntity
            try await coreDataWrapper.save(cartItemEntity)
        }
    }
    
    public func updateItem(_ item: CartItem, for user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let fetchedItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        
        if let cartItemEntity = fetchedItems.first(where: { $0.id == item.id }) {
            cartItemEntity.quantity = Int16(item.quantity)
            try await coreDataWrapper.update(cartItemEntity)
        }
    }
    
    public func removeItem(_ item: CartItem, from user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let fetchedItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        
        if let cartItemEntity = fetchedItems.first(where: { $0.id == item.id }) {
            try await coreDataWrapper.delete(cartItemEntity)
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchOrCreateCartEntity(for user: User) async throws -> CartEntity {
        let predicate = NSPredicate(format: "user.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataWrapper.fetch(entityName: "CartEntity", predicate: predicate)
        
        if let cart = fetchedCarts.first {
            return cart
        } else {
            let newCart = CartEntity(context: coreDataWrapper.context)
            newCart.id = UUID()
            newCart.user = user.toUserEntity(context: coreDataWrapper.context)
            try await coreDataWrapper.save(newCart)
            return newCart
        }
    }
    
    private func fetchProductEntity(from product: Product) async throws -> ProductEntity {
        let predicate = NSPredicate(format: "id == %d", product.id)
        let fetchedProducts: [ProductEntity] = try await coreDataWrapper.fetch(entityName: "ProductEntity", predicate: predicate)
        
        if let productEntity = fetchedProducts.first {
            return productEntity
        } else {
            // Create new ProductEntity
            let productEntity = ProductEntity(context: coreDataWrapper.context)
            productEntity.id = Int64(product.id)
            productEntity.price = product.price
            productEntity.title = product.title
            productEntity.productDescription = product.description
            productEntity.category = product.category
            productEntity.thumbnail = product.thumbnail
            productEntity.brand = product.brand
            productEntity.discountPercentage = product.discountPercentage
            productEntity.rating = product.rating
            productEntity.stock = Int32(product.stock)
            try await coreDataWrapper.save(productEntity)
            return productEntity
        }
    }
}
