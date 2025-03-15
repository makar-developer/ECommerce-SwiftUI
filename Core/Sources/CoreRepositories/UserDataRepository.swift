//
//  UserDataRepository.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreData
import CoreDataSources
import CoreEntities
import Foundation

public protocol UserDataRepositoryProtocol {
    func createUserData(_ user: User) async throws
    func deleteUserData(byId id: UUID) async throws
    func fetchUserData(byId id: UUID) async throws -> UUID?
}

public final class UserDataRepository: UserDataRepositoryProtocol {
    private let coreDataDataSource: CoreDataDataSourceProtocol

    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource
    }

    public func createUserData(_ user: User) async throws {
        let context = coreDataDataSource.context
        let request: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let existing: [UserDataEntity] = try await coreDataDataSource.fetch(request)

        if existing.isEmpty {
            _ = user.toCoreData(context: context)
            try await coreDataDataSource.save()
        } else {
            throw NSError(
                domain: "UserDataRepository",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "UserDataEntity already exists"]
            )
        }
    }

    public func deleteUserData(byId id: UUID) async throws {
        let request: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataDataSource.fetch(request)

        if let userDataEntity = fetched.first {
            try await coreDataDataSource.delete(userDataEntity)
        } else {
            throw NSError(
                domain: "UserDataRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "UserDataEntity not found"]
            )
        }
    }

    public func fetchUserData(byId id: UUID) async throws -> UUID? {
        let request: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetched: [UserDataEntity] = try await coreDataDataSource.fetch(request)
        return fetched.first?.id
    }
}

public final class MockUserDataRepository: UserDataRepositoryProtocol {
    // Track the number of calls for each method
    private(set) var createUserDataCallCount = 0
    private(set) var deleteUserDataCallCount = 0
    private(set) var fetchUserDataCallCount = 0

    // Store the parameters captured from calls
    private(set) var capturedUserForCreate: User?
    private(set) var capturedUserIdForDelete: UUID?
    private(set) var capturedUserIdForFetch: UUID?

    // Provide a return value or throw errors as needed
    public var fetchUserDataReturnValue: UUID?
    public var createUserDataErrorToThrow: Error?
    public var deleteUserDataErrorToThrow: Error?
    public var fetchUserDataErrorToThrow: Error?

    public init() {}

    public func createUserData(_ user: User) async throws {
        createUserDataCallCount += 1
        capturedUserForCreate = user

        if let error = createUserDataErrorToThrow {
            throw error
        }
    }

    public func deleteUserData(byId id: UUID) async throws {
        deleteUserDataCallCount += 1
        capturedUserIdForDelete = id

        if let error = deleteUserDataErrorToThrow {
            throw error
        }
    }

    public func fetchUserData(byId id: UUID) async throws -> UUID? {
        fetchUserDataCallCount += 1
        capturedUserIdForFetch = id

        if let error = fetchUserDataErrorToThrow {
            throw error
        }

        return fetchUserDataReturnValue
    }
}
