//
//  File 2.swift
//
//
//  Created by Admin on 25/11/2024.
//

import CoreEntities
import Foundation
import WelcomeRepositoryProtocol

public protocol DeleteUserUseCaseProtocol {
    func execute(user: User) async throws
}

public final class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    let welcomeRepository: WelcomeRepositoryProtocol

    public init(welcomeRepository: WelcomeRepositoryProtocol) {
        self.welcomeRepository = welcomeRepository
    }

    public func execute(user: User) async throws {
        try await welcomeRepository.delete(user: user)
    }
}

public final class MockDeleteUserUseCase: DeleteUserUseCaseProtocol {
    public var shouldThrowError = false
    public var deletedUserIDs: [UUID] = []

    public init() {}

    public func execute(user: User) async throws {
        if shouldThrowError {
            throw NSError(domain: "DeleteUserError", code: 1, userInfo: nil)
        }
        deletedUserIDs.append(user.id)
    }
}
