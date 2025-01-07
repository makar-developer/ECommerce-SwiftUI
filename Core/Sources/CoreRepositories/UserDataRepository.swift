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
        // Check if user already exists
        let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let existingUsers: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        
        if existingUsers.isEmpty {
            // Create new UserDataEntity
            let userDataEntity = user.toUserDataEntity(context: context)
            try await coreDataWrapper.save(userDataEntity)
        } else {
            // User already exists
            throw NSError(domain: "UserDataRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "UserDataEntity already exists"])
        }
    }
    
    public func deleteUserData(byId id: UUID) async throws {
//        let context = coreDataWrapper.context
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let users: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        
        if let userDataEntity = users.first {
            try await coreDataWrapper.delete(userDataEntity)
        } else {
            // User not found
            throw NSError(domain: "UserDataRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "UserDataEntity not found"])
        }
    }
    
    public func fetchUserData(byId id: UUID) async throws -> UUID? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let users: [UserDataEntity] = try await coreDataWrapper.fetch(entityName: "UserDataEntity", predicate: predicate)
        return users.first?.id
    }
}
