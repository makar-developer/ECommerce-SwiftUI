//
//  File.swift
//  
//
//  Created by Admin on 15/12/2024.
//

import CoreDataSources
import CoreEntities
import Foundation

public protocol AuthenticationRepositoryProtocol {
    func signIn(user: User) async throws
    func signOut() async throws
    func getSignedInUser() async throws -> User?
}

public final class AuthenticationRepository: AuthenticationRepositoryProtocol {
    private let keychainWrapper: KeychainWrapperProtocol

    public init(keychainWrapper: KeychainWrapperProtocol) {
        self.keychainWrapper = keychainWrapper
    }
    
    public func signIn(user: User) async throws {
        let data = try JSONEncoder().encode(user)
        try keychainWrapper.save(data: data)
    }

    public func signOut() async throws {
        try keychainWrapper.delete()
    }

    public func getSignedInUser() async throws -> User? {
        guard let data = try keychainWrapper.load() else { return nil }
        return try JSONDecoder().decode(User.self, from: data)
    }
}
