//
//  AuthenticationRepository.swift
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
    private let keychainDataSource: KeychainDataSourceProtocol

    public init(keychainDataSource: KeychainDataSourceProtocol) {
        self.keychainDataSource = keychainDataSource
    }

    public func signIn(user: User) async throws {
        let data = try JSONEncoder().encode(user)
        try keychainDataSource.save(data: data)
    }

    public func signOut() async throws {
        try keychainDataSource.delete()
    }

    public func getSignedInUser() async throws -> User? {
        guard let data = try keychainDataSource.load() else { return nil }
        return try JSONDecoder().decode(User.self, from: data)
    }
}

public final class MockAuthenticationRepository: AuthenticationRepositoryProtocol {
    // In-memory user representation
    private(set) var storedUser: User?

    // For test assertions
    public var didSignIn = false
    public var didSignOut = false
    public var didGetSignedInUser = false

    public init() {}

    public func signIn(user: User) async throws {
        didSignIn = true
        storedUser = user
    }

    public func signOut() async throws {
        didSignOut = true
        storedUser = nil
    }

    public func getSignedInUser() async throws -> User? {
        didGetSignedInUser = true
        return storedUser
    }
}
