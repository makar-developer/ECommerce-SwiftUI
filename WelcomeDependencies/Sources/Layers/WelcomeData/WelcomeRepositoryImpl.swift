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
    
    private let keychainWrapper: KeychainWrapperProtocol
    private let usersFetchedKey = "hasFetchedUsersBefore"
    
    public init() {
        self.keychainWrapper = KeychainWrapper(service: "com.yourapp.welcome", account: "users")
    }
    
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
            guard let data = try keychainWrapper.load() else {
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
        try keychainWrapper.save(data: data)
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
}

