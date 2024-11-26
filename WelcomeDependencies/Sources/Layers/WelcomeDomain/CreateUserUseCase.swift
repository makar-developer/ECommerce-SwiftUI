//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import WelcomeEntities
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
