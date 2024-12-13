//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import CoreEntities

// MARK: - WelcomeRepositoryProtocol

public protocol WelcomeRepositoryProtocol {
    func getUsers() async throws -> [User]
    func delete(user: User) async throws
    func saveUsers(_ users: [User]) async throws
    func saveUser(_ user: User) async throws
}
