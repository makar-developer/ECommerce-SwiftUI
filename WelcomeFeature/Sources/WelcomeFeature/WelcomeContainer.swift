//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import Foundation
import WelcomeRepositoryProtocol
import WelcomeData
import WelcomeDomain
public protocol WelcomeDIContainerProtocol {
    var getAllUsersUseCase: GetAllUsersUseCaseProtocol { get }
    var logoutUserUseCase: LogoutUserUseCaseProtocol { get }
    var welcomeRepository: WelcomeRepositoryProtocol { get }
}

public class WelcomeDIContainerImpl: WelcomeDIContainerProtocol {
    // MARK: - Repositories
    public lazy var welcomeRepository: WelcomeRepositoryProtocol = {
        return WelcomeRepositoryImpl()
    }()
    
    // MARK: - Use Cases
    public lazy var getAllUsersUseCase: GetAllUsersUseCaseProtocol = {
        return GetAllUsersUseCase(welcomeRepository: welcomeRepository)
    }()
    
    public lazy var logoutUserUseCase: LogoutUserUseCaseProtocol = {
        return LogoutUserUseCase(welcomeRepository: welcomeRepository)
    }()
    
    public init() {}
}
