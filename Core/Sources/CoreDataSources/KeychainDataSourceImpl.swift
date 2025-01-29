//
//  File.swift
//  
//
//  Created by Admin on 09/12/2024.
//


import Security
import Foundation
public enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}

public protocol KeychainDataSourceProtocol {
    /// Save data to the keychain
    /// - Parameter data: The data to save
    /// - Throws: An error if the data cannot be saved
    func save(data: Data) throws
    
    /// Load data from the keychain
    /// - Returns: The retrieved data, or `nil` if no data was found
    /// - Throws: An error if the data cannot be loaded
    func load() throws -> Data?
    
    /// Delete data from the keychain
    /// - Throws: An error if the data cannot be deleted
    func delete() throws
}

public final class KeychainDataSourceImpl: KeychainDataSourceProtocol {
    
    private let service: String
    private let account: String
    
    public init(service: String, account: String) {
        self.service = service
        self.account = account
    }
    
    public func save(data: Data) throws {
        // Delete any existing item
        try? delete()
        
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
    
    public func load() throws -> Data? {
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
    
    public func delete() throws {
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

public final class MockKeychainDataSource: KeychainDataSourceProtocol {
    
    public init() {}
    
    public var storedData: Data?

    private(set) var didCallSave = false
    private(set) var didCallLoad = false
    private(set) var didCallDelete = false

    public func save(data: Data) throws {
        didCallSave = true
        storedData = data
    }

    public func load() throws -> Data? {
        didCallLoad = true
        return storedData
    }

    public func delete() throws {
        didCallDelete = true
        storedData = nil
    }
}
