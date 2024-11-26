//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import WelcomeEntities

// MARK: - WelcomeRepositoryProtocol

public protocol WelcomeRepositoryProtocol {
    func getUsers() async throws -> [User]
    func logout(user: User) async throws
    func saveUsers(_ users: [User]) async throws
    func saveUser(_ user: User) async throws
}
