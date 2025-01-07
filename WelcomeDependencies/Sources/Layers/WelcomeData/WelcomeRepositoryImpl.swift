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
//import CoreRepositories

// MARK: - WelcomeRepositoryImpl

public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
    
    private let keychainWrapper: KeychainWrapperProtocol
    private let usersFetchedKey = "hasFetchedUsersBefore"
    
    public init(keychainWrapper: KeychainWrapperProtocol) {
        self.keychainWrapper = keychainWrapper
    }

    public func getUsers() async throws -> [User] {
            // Subsequent fetches: retrieve users from Keychain
            guard let data = try keychainWrapper.load() else {
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
        try keychainWrapper.save(data: data)
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

