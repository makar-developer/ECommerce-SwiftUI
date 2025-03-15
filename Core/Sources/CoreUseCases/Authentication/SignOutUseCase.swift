//
//  SignOutUseCase.swift
//
//
//  Created by Admin on 15/12/2024.
//

import CoreRepositories

public protocol SignOutUseCaseProtocol {
    func execute() async throws
}

public final class SignOutUseCase: SignOutUseCaseProtocol {
    private let repository: AuthenticationRepositoryProtocol

    public init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.signOut()
    }
}
