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
    func removeProductFromHistory(_ productHistory: ProductHistory, for userId: UUID) async throws
    func removeAllHistory(for userId: UUID) async throws
    func removeHistory(olderThan date: Date, for userId: UUID) async throws
}

public class ProductHistoryRepository: ProductHistoryRepositoryProtocol {
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
            return historyEntities.compactMap { $0.toDomainModel() }
        }
    }

    public func addProductToHistory(_ product: Product, for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            // Fetch or create the product entity
            let productEntity = product.toCoreDataEntity(context: context)
            // Fetch the user entity
            let userFetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            guard let userEntity = try context.fetch(userFetchRequest).first else {
                throw NSError(domain: "User not found", code: 404, userInfo: nil)
            }

            // Create new history entity
            let history = ProductHistory(product: product)
            let historyEntity = history.toCoreDataEntity(context: context)
            historyEntity.userData = userEntity
            historyEntity.product = productEntity

            // Save context
            try context.save()
        }
    }

    public func removeProductFromHistory(_ productHistory: ProductHistory, for userId: UUID) async throws {
        let context = coreDataWrapper.context
        try await context.perform {
            let fetchRequest: NSFetchRequest<ProductHistoryEntity> = ProductHistoryEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@ AND userData.id == %@", productHistory.id as CVarArg, userId as CVarArg)
            if let entityToDelete = try context.fetch(fetchRequest).first {
                context.delete(entityToDelete)
                try context.save()
            }
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
            fetchRequest.predicate = NSPredicate(format: "timestamp < %@ AND userData.id == %@", date as NSDate, userId as CVarArg)
            let historyEntities = try context.fetch(fetchRequest)
            for entity in historyEntities {
                context.delete(entity)
            }
            try context.save()
        }
    }
}
