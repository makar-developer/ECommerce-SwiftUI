//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreData
import CoreEntities
import CoreDataSources

public protocol UserDataRepositoryProtocol {
    func createUserData(_ user: User) async throws
    func deleteUserData(byId id: UUID) async throws
    func fetchUserData(byId id: UUID) async throws -> UUID?
}


import CoreData

public final class UserDataRepository: UserDataRepositoryProtocol {
    private let coreDataWrapper: CoreDataWrapperProtocol

    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }

    public func createUserData(_ user: User) async throws {
        let context = coreDataWrapper.context
        let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let existing: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        
        if existing.isEmpty {
            let entity = user.toCoreData(context: context)
            try await coreDataWrapper.save(entity)
        } else {
            throw NSError(
                domain: "UserDataRepository",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "UserDataEntity already exists"]
            )
        }
    }

    public func deleteUserData(byId id: UUID) async throws {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)

        if let userDataEntity = fetched.first {
            try await coreDataWrapper.delete(userDataEntity)
        } else {
            throw NSError(
                domain: "UserDataRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "UserDataEntity not found"]
            )
        }
    }

    public func fetchUserData(byId id: UUID) async throws -> UUID? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        return fetched.first?.id
    }
}
