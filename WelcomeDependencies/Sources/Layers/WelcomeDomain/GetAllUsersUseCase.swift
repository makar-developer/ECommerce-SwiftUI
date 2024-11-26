//
//  File.swift
//  
//
//  Created by Admin on 25/11/2024.
//

import WelcomeRepositoryProtocol
import WelcomeEntities


public protocol GetAllUsersUseCaseProtocol {
    func execute() async throws -> [User]
}

public final class GetAllUsersUseCase: GetAllUsersUseCaseProtocol {
    
    let welcomeRepository: WelcomeRepositoryProtocol
    
    public init(welcomeRepository: WelcomeRepositoryProtocol) {
        self.welcomeRepository = welcomeRepository
    }
    
    public func execute() async throws -> [User] {
        // Fetch users logic
        return try await welcomeRepository.getUsers()
    }
}

