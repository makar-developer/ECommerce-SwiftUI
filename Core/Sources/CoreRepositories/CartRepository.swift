//
//  CartRepository.swift
//
//
//  Created by Admin on 29/11/2024.
//

import CoreData
import CoreDataSources
import CoreEntities
import Foundation

// MARK: - CartRepositoryProtocol

public protocol CartRepositoryProtocol {
    func getCart(for user: User) async throws -> Cart
    func addItem(_ item: CartItem, to user: User) async throws
    func updateItem(_ item: CartItem, for user: User) async throws
    func removeItem(_ item: CartItem, from user: User) async throws
}

// MARK: - CartRepositoryImpl

public final class CartRepositoryImpl: CartRepositoryProtocol {
    private let coreDataDataSource: CoreDataDataSourceProtocol

    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource
    }

    public func getCart(for user: User) async throws -> Cart {
        let request: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userData.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataDataSource.fetch(request)

        guard let cartEntity = fetchedCarts.first else {
            // If no cart exists, create a new one
            let newCart = Cart(products: [], id: UUID(), userId: user.id)
            let newCartEntity = newCart.toCoreData(context: coreDataDataSource.context)
            // Link to user
            let userDataEntity = try await fetchOrCreateUserDataEntity(for: user)
            newCartEntity.userData = userDataEntity
            try await coreDataDataSource.save()
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
            try await coreDataDataSource.save()
        } else {
            // Create new cart item
            let cartItemEntity = item.toCoreData(context: coreDataDataSource.context)
            cartItemEntity.product = productEntity
            cartItemEntity.cart = cartEntity
            try await coreDataDataSource.save()
        }
    }

    public func updateItem(_ item: CartItem, for user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let existingItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        if let cartItemEntity = existingItems.first(where: { $0.id == item.id }) {
            cartItemEntity.quantity = Int16(item.quantity)
            try await coreDataDataSource.save()
        }
    }

    public func removeItem(_ item: CartItem, from user: User) async throws {
        let cartEntity = try await fetchOrCreateCartEntity(for: user)
        let existingItems = cartEntity.products?.allObjects as? [CartItemEntity] ?? []
        if let cartItemEntity = existingItems.first(where: { $0.id == item.id }) {
            try await coreDataDataSource.delete(cartItemEntity)
        }
    }

    // MARK: - Private Helpers

    private func fetchOrCreateCartEntity(for user: User) async throws -> CartEntity {
        let request: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userData.id == %@", user.id as CVarArg)
        let fetchedCarts: [CartEntity] = try await coreDataDataSource.fetch(request)

        if let existingCart = fetchedCarts.first {
            return existingCart
        } else {
            let newCart = Cart(products: [], id: UUID(), userId: user.id)
            let newCartEntity = newCart.toCoreData(context: coreDataDataSource.context)
            let userDataEntity = try await fetchOrCreateUserDataEntity(for: user)
            newCartEntity.userData = userDataEntity
            try await coreDataDataSource.save()
            return newCartEntity
        }
    }

    private func fetchOrCreateProductEntity(from product: Product) async throws -> ProductEntity {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", product.id)
        let fetched: [ProductEntity] = try await coreDataDataSource.fetch(request)
        if let existingEntity = fetched.first {
            return existingEntity
        } else {
            let entity = product.toCoreData(context: coreDataDataSource.context)
            try await coreDataDataSource.save()
            return entity
        }
    }

    private func fetchOrCreateUserDataEntity(for user: User) async throws -> UserDataEntity {
        let request: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataDataSource.fetch(request)
        if let userDataEntity = fetched.first {
            return userDataEntity
        } else {
            let entity = user.toCoreData(context: coreDataDataSource.context)
            try await coreDataDataSource.save()
            return entity
        }
    }
}

public final class MockCartRepository: CartRepositoryProtocol {
    // In-memory storage of user carts
    private var userCarts: [UUID: Cart] = [:]

    // For test verifications
    public var didGetCart = false
    public var didAddItem = false
    public var didUpdateItem = false
    public var didRemoveItem = false

    public init() {}

    public func getCart(for user: User) async throws -> Cart {
        didGetCart = true
        if let existingCart = userCarts[user.id] {
            return existingCart
        } else {
            let newCart = Cart(products: [], id: UUID(), userId: user.id)
            userCarts[user.id] = newCart
            return newCart
        }
    }

    public func addItem(_ item: CartItem, to user: User) async throws {
        didAddItem = true
        var cart = try await getCart(for: user)
        if let index = cart.products.firstIndex(where: { $0.product.id == item.product.id }) {
            cart.products[index].quantity += item.quantity
        } else {
            cart.products.append(item)
        }
        userCarts[user.id] = cart
    }

    public func updateItem(_ item: CartItem, for user: User) async throws {
        didUpdateItem = true
        var cart = try await getCart(for: user)
        if let index = cart.products.firstIndex(where: { $0.id == item.id }) {
            cart.products[index] = item
        }
        userCarts[user.id] = cart
    }

    public func removeItem(_ item: CartItem, from user: User) async throws {
        didRemoveItem = true
        var cart = try await getCart(for: user)
        cart.products.removeAll { $0.id == item.id }
        userCarts[user.id] = cart
    }
}
