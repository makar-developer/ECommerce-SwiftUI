//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import Foundation
import WelcomeRepositoryProtocol
import CoreEntities
import Security
import CoreDataSources

// MARK: - WelcomeRepositoryImpl

public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
    
    private let keychainDataSource: KeychainDataSourceProtocol
    private let usersFetchedKey = "hasFetchedUsersBefore"
    
    public init(keychainDataSource: KeychainDataSourceProtocol) {
        self.keychainDataSource = keychainDataSource
    }

    public func getUsers() async throws -> [User] {
            // Subsequent fetches: retrieve users from Keychain
            guard let data = try keychainDataSource.load() else {
                // Handle the case where no users are found in Keychain
                return []
            }
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
    }
    
    public func delete(user: User) async throws {
        try await deleteUser(user)
    }
    
    public func saveUsers(_ users: [User]) async throws {
        let data = try JSONEncoder().encode(users)
        try keychainDataSource.save(data: data)
    }
    
    public func saveUser(_ user: User) async throws {
        var users = try await getUsers()
        users.append(user)
        try await saveUsers(users)
    }
    
    private func deleteUser(_ user: User) async throws {
        var users = try await getUsers()
        users.removeAll { $0.id == user.id }
        try await saveUsers(users)
    }
}

public final class MockWelcomeRepository: WelcomeRepositoryProtocol {
    
    public var storedUsers: [User] = []
    
    // Track calls
    public private(set) var getUsersCallCount = 0
    public private(set) var deleteCallCount = 0
    public private(set) var saveUserCallCount = 0
    
    public init() {}
    
    public func getUsers() async throws -> [User] {
        getUsersCallCount += 1
        return storedUsers
    }
    
    public func delete(user: User) async throws {
        deleteCallCount += 1
        storedUsers.removeAll { $0.id == user.id }
    }
    
    public func saveUsers(_ users: [User]) async throws {
        storedUsers = users
    }
    
    public func saveUser(_ user: User) async throws {
        saveUserCallCount += 1
        storedUsers.append(user)
    }
}
