//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import Foundation
import WelcomeRepositoryProtocol
import WelcomeEntities

import Security



// MARK: - WelcomeRepositoryImpl

public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
    
    private let service = "com.yourapp.welcome"
    private let account = "users"
    
    public init() {}
    
    public func getUsers() async throws -> [User] {
        guard let data = try loadFromKeychain() else {
            // Return default users if none are stored
            return [
                User(name: "DefaultUser1", image: "image1", login: "user1", password: "password1"),
                User(name: "DefaultUser2", image: "image2", login: "user2", password: "password2"),
                User(name: "DefaultUser3", image: "image3", login: "user3", password: "password3")
            ]
        }
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
    
    public func logout(user: User) async throws {
        try await deleteUser(user)
    }
    
    public func saveUsers(_ users: [User]) async throws {
        let data = try JSONEncoder().encode(users)
        try saveToKeychain(data: data)
    }
    
    private func deleteUser(_ user: User) async throws {
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




//public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
//
//    public init() {}
//
//    public func getUsers() async throws -> [WelcomeEntities.User] {
//        return [
//            User(name: "DefaultUser1", image: "image1", login: "login1", password: "password1"),
//                User(name: "DefaultUser2", image: "image2", login: "login2", password: "password2"),
//            User(name: "DefaultUser3", image: "image3", login: "login3", password: "password3")
//
//        ]
//    }
//
//    public func logout(user: WelcomeEntities.User) async throws {
//        // . . .
//    }
//
//
//}



	



















//import KeychainSwift
//
//// Assuming you have a User model like this; adjust as needed.
//public struct User: Codable, Equatable, Identifiable {
//    public let id: UUID
//    public let name: String
//    public let image: String? // Assuming image might be a URL or identifier
//
//    public init(id: UUID = UUID(), name: String, image: String? = nil) {
//        self.id = id
//        self.name = name
//        self.image = image
//    }
//    
//    public static func == (lhs: User, rhs: User) -> Bool {
//            return lhs.id == rhs.id
//        }
//}
//
//// Define possible errors for the repository
//public enum WelcomeRepositoryError: Error {
//    case userNotFound
//    case keychainError(status: OSStatus)
//    case encodingError
//    case decodingError
//}
//
//// Protocol Definition
//public protocol WelcomeRepositoryProtocol {
//    func getUsers() async throws -> [User]
//    func logout(user: User) async throws
//    func saveUser(_ user: User) async throws
//}
//
//// Concrete Implementation using KeychainSwift
//public final class WelcomeRepositoryImpl: WelcomeRepositoryProtocol {
//    private let keychain = KeychainSwift()
//    private let usersKey = "com.yourappname.users" // Unique key for storing users in Keychain
//    private let jsonEncoder = JSONEncoder()
//    private let jsonDecoder = JSONDecoder()
//
//    public init() {}
//
//    public func getUsers() async throws -> [User] {
//        guard let savedData = keychain.getData(usersKey) else { return [] }
//
//        do {
//            return try jsonDecoder.decode([User].self, from: savedData)
//        } catch {
//            throw WelcomeRepositoryError.decodingError
//        }
//    }
//
//
//    public func saveUser(_ user: User) async throws {
//        var users = try await getUsers()
//        if !users.contains(where: { $0.id == user.id }) {
//            users.append(user)
//            await updateUsersInKeychain(users)
//        }
//    }
//
//
//    public func logout(user: User) async throws {
//        var users = try await getUsers()
//        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
//            throw WelcomeRepositoryError.userNotFound
//        }
//        users.remove(at: index)
//        await updateUsersInKeychain(users)
//    }
//
//    private func updateUsersInKeychain(_ users: [User]) async {
//        do {
//            let data = try jsonEncoder.encode(users)
//            let success = keychain.set(data, forKey: usersKey)
//            if !success {
//                throw WelcomeRepositoryError.keychainError(status: keychain.lastResultCode)
//            }
//        } catch {
//            print("Error updating users in keychain: \(error)")
//        }
//    }
//}
