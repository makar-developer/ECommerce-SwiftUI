//
//  File 2.swift
//  
//
//  Created by Admin on 25/11/2024.
//

import WelcomeRepositoryProtocol
import CoreEntities
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
