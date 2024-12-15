//
//  File.swift
//  
//
//  Created by Admin on 15/12/2024.
//

import CoreRepositories
import CoreEntities

public protocol SignInUseCaseProtocol {
    func execute(user: User) async throws
}

public final class SignInUseCase: SignInUseCaseProtocol {
    private let repository: AuthenticationRepositoryProtocol

    public init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(user: User) async throws {
        try await repository.signIn(user: user)
    }
}
