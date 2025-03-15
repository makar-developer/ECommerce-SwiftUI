//
//  CreateUserUseCase.swift
//
//
//  Created by Admin on 26/11/2024.
//

import CoreEntities
import Foundation
import WelcomeRepositoryProtocol

public protocol CreateUserUseCaseProtocol {
    func execute(user: User) async throws
}

public final class CreateUserUseCase: CreateUserUseCaseProtocol {
    private let welcomeRepository: WelcomeRepositoryProtocol

    public init(welcomeRepository: WelcomeRepositoryProtocol) {
        self.welcomeRepository = welcomeRepository
    }

    public func execute(user: User) async throws {
        try await welcomeRepository.saveUser(user)
    }
}

public final class MockCreateUserUseCase: CreateUserUseCaseProtocol {
    public init() {}

    var shouldThrowError = false
    var createdUsers: [User] = []

    public func execute(user: User) async throws {
        if shouldThrowError {
            throw NSError(domain: "CreateUserError", code: 1, userInfo: nil)
        }
        createdUsers.append(user)
    }
}
