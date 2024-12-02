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



// MARK: - WelcomeRepositoryImpl

public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
    
    private let service = "com.yourapp.welcome"
    private let account = "users"
    private let usersFetchedKey = "hasFetchedUsersBefore"
    
    public init() {}
    
    public func getUsers() async throws -> [User] {
        let isFirstFetch = !UserDefaults.standard.bool(forKey: usersFetchedKey)
        
        if isFirstFetch {
            // Initialize default users using compactMap
            let userData = [
                ("DefaultUser1", "image1", "user1", "Password1@"),
                ("DefaultUser2", "image2", "user2", "Password2@"),
                ("DefaultUser3", "image1", "user1", "Password1@"),
                ("DefaultUser4", "image2", "user2", "Password2@"),
                ("DefaultUser5", "image3", "user3", "Password3@")
            ]
            
            let defaultUsers: [User] = userData.compactMap { (nameString, image, loginString, passwordString) in
                guard let name = UserName(nameString),
                      let login = Login(loginString),
                      let password = Password(passwordString) else {
                    // Optionally handle invalid data
                    print("Invalid user data for \(nameString)")
                    return nil
                }
                return User(
                    name: name,
                    image: image,
                    login: login,
                    password: password
                )
            }

            try await saveUsers(defaultUsers)
            
            // Update UserDefaults to indicate that the initial fetch has occurred
            UserDefaults.standard.set(true, forKey: usersFetchedKey)
            
            return defaultUsers
        } else {
            // Subsequent fetches: retrieve users from Keychain
            guard let data = try loadFromKeychain() else {
                // Handle the case where no users are found in Keychain
                return []
            }
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        }
    }
    
    public func logout(user: User) async throws {
        try await deleteUser(user)
    }
    
    public func saveUsers(_ users: [User]) async throws {
        let data = try JSONEncoder().encode(users)
        try saveToKeychain(data: data)
    }
    
    public func saveUser(_ user: User) async throws {
        var users = try await getUsers()
        users.append(user)
        try await saveUsers(users)
    }
    
    public func deleteUser(_ user: User) async throws {
        var users = try await getUsers()
        users.removeAll { $0.id == user.id }
        try await saveUsers(users)
    }
    
    // MARK: - Keychain Helpers
    
    private func saveToKeychain(data: Data) throws {
        // Delete existing item if it exists
        try? deleteFromKeychain()
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private func loadFromKeychain() throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String         : kSecClassGenericPassword,
            kSecAttrService as String   : service,
            kSecAttrAccount as String   : account,
            kSecReturnData as String    : true,
            kSecMatchLimit as String    : kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        return item as? Data
    }
    
    private func deleteFromKeychain() throws {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}

// MARK: - KeychainError

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}



