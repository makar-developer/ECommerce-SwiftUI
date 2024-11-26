//
//  File 2.swift
//  
//
//  Created by Admin on 25/11/2024.
//

import WelcomeRepositoryProtocol
import WelcomeEntities
public protocol LogoutUserUseCaseProtocol {
    func execute(user: User) async throws
}

public final class LogoutUserUseCase: LogoutUserUseCaseProtocol {
    
    let welcomeRepository: WelcomeRepositoryProtocol
    
    public init(welcomeRepository: WelcomeRepositoryProtocol) {
        self.welcomeRepository = welcomeRepository
    }
    
    public func execute(user: User) async throws {
        // Logout logic
    }
}
