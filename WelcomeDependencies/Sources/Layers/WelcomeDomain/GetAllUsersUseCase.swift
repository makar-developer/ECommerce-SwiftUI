//
//  GetAllUsersUseCase.swift
//
//
//  Created by Admin on 25/11/2024.
//

import CoreEntities
import Foundation
import WelcomeRepositoryProtocol

public protocol GetAllUsersUseCaseProtocol {
    func execute() async throws -> [User]
}

public final class GetAllUsersUseCase: GetAllUsersUseCaseProtocol {
    let welcomeRepository: WelcomeRepositoryProtocol

    public init(welcomeRepository: WelcomeRepositoryProtocol) {
        self.welcomeRepository = welcomeRepository
    }

    public func execute() async throws -> [User] {
        return try await welcomeRepository.getUsers()
    }
}

public final class MockGetAllUsersUseCase: GetAllUsersUseCaseProtocol {
    public var shouldThrowError = false
    public var returnedUsers: [User] = []

    public init() {}

    public func execute() async throws -> [User] {
        if shouldThrowError {
            throw NSError(domain: "GetAllUsersError", code: 1, userInfo: nil)
        }
        return returnedUsers
    }
}
