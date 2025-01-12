//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import CoreDataSources
import CoreEntities
import CoreData
public protocol ProductHistoryRepositoryProtocol {
    func getAllHistory(for userId: UUID) async throws -> [ProductHistory]
    func addProductToHistory(_ product: Product, for userId: UUID) async throws
    func removeProductHistory(_ product: Product, for userId: UUID) async throws
    func removeAllHistory(for userId: UUID) async throws
    func removeHistory(olderThan date: Date, for userId: UUID) async throws
}

public final class ProductHistoryRepository: ProductHistoryRepositoryProtocol {
    private let coreDataWrapper: CoreDataWrapperProtocol

    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }

    public func getAllHistory(for userId: UUID) async throws -> [ProductHistory] {
        let context = coreDataWrapper.context
        return try await context.perform {
            let fetchRequest: NSFetchRequest<ProductHistoryEntity> = ProductHistoryEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userData.id == %@", userId as CVarArg)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let historyEntities = try context.fetch(fetchRequest)
            return historyEntities.compactMap { $0.toDomain() }
        }
    }

    public func addProductToHistory(_ product: Product, for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            // 1. Fetch or create the product entity
            let productEntity = try self.fetchOrCreateProductEntity(product, in: context)
            
            // 2. Fetch user entity
            let userFetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            guard let userEntity = try context.fetch(userFetchRequest).first else {
                throw NSError(domain: "User not found", code: 404, userInfo: nil)
            }

            // 3. Create new history entity
            let history = ProductHistory(product: product)
            let historyEntity = history.toCoreData(context: context)
            historyEntity.userData = userEntity
            historyEntity.product = productEntity

            // 4. Save changes
            try context.save()
        }
    }

    public func removeProductHistory(_ product: Product, for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            let fetchRequest: NSFetchRequest<ProductHistoryEntity> = ProductHistoryEntity.fetchRequest()
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "product.id == %d", product.id),
                NSPredicate(format: "userData.id == %@", userId as CVarArg)
            ])
            fetchRequest.predicate = predicate
            let historyEntities = try context.fetch(fetchRequest)
            for entity in historyEntities {
                context.delete(entity)
            }
            try context.save()
        }
    }

    public func removeAllHistory(for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            let fetchRequest: NSFetchRequest<ProductHistoryEntity> = ProductHistoryEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userData.id == %@", userId as CVarArg)
            let historyEntities = try context.fetch(fetchRequest)
            for entity in historyEntities {
                context.delete(entity)
            }
            try context.save()
        }
    }

    public func removeHistory(olderThan date: Date, for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            let fetchRequest: NSFetchRequest<ProductHistoryEntity> = ProductHistoryEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "timestamp < %@ AND userData.id == %@",
                date as NSDate, userId as CVarArg
            )
            let historyEntities = try context.fetch(fetchRequest)
            for entity in historyEntities {
                context.delete(entity)
            }
            try context.save()
        }
    }
    
    // MARK: - Helper

    private func fetchOrCreateProductEntity(
        _ product: Product,
        in context: NSManagedObjectContext
    ) throws -> ProductEntity {
        let predicate = NSPredicate(format: "id == %d", product.id)
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = predicate
        
        let fetched = try context.fetch(request)
        if let existing = fetched.first {
            return existing
        } else {
            let newEntity = product.toCoreData(context: context)
            try context.save()
            return newEntity
        }
    }
}

public final class MockProductHistoryRepository: ProductHistoryRepositoryProtocol {
    
    // Track method calls
    private(set) var getAllHistoryCallCount = 0
    private(set) var addProductToHistoryCallCount = 0
    private(set) var removeProductHistoryCallCount = 0
    private(set) var removeAllHistoryCallCount = 0
    private(set) var removeHistoryOlderThanCallCount = 0
    
    // Track captured parameters
    private(set) var capturedProduct: Product?
    private(set) var capturedUserId: UUID?
    private(set) var capturedDate: Date?
    
    // Provide a return value for getAllHistory
    var getAllHistoryReturnValue: [ProductHistory] = []
    
    public init() {}
    
    public func getAllHistory(for userId: UUID) async throws -> [ProductHistory] {
        getAllHistoryCallCount += 1
        capturedUserId = userId
        return getAllHistoryReturnValue
    }

    public func addProductToHistory(_ product: Product, for userId: UUID) async throws {
        addProductToHistoryCallCount += 1
        capturedProduct = product
        capturedUserId = userId
    }

    public func removeProductHistory(_ product: Product, for userId: UUID) async throws {
        removeProductHistoryCallCount += 1
        capturedProduct = product
        capturedUserId = userId
    }

    public func removeAllHistory(for userId: UUID) async throws {
        removeAllHistoryCallCount += 1
        capturedUserId = userId
    }

    public func removeHistory(olderThan date: Date, for userId: UUID) async throws {
        removeHistoryOlderThanCallCount += 1
        capturedDate = date
        capturedUserId = userId
    }
}
