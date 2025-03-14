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
import CoreUseCases
import CoreRepositories
import CoreDataSources
public protocol WelcomeDIContainerProtocol {
    // MARK: - Use Cases
    func makeGetAllUsersUseCase() -> GetAllUsersUseCaseProtocol
    func makeDeleteUserUseCase() -> DeleteUserUseCaseProtocol
    func makeCreateUserUseCase() -> CreateUserUseCaseProtocol
    func makeSignInUseCase() -> CoreUseCases.SignInUseCaseProtocol
    func makeSignOutUseCase() -> CoreUseCases.SignOutUseCaseProtocol
    func makeGetSignedInUserUseCase() -> CoreUseCases.GetSignedInUserUseCaseProtocol
}

public struct WelcomeDIContainerImpl: WelcomeDIContainerProtocol {
    
    private let keychainDataSource: KeychainDataSourceProtocol
    private let authenticationKeychainDataSource: KeychainDataSourceProtocol
    private let welcomeRepository: WelcomeRepositoryProtocol
    private let authenticationRepository: AuthenticationRepositoryProtocol
    
    public init() {
        self.keychainDataSource = KeychainDataSourceImpl(service: "com.yourapp.welcome", account: "users")
        self.authenticationKeychainDataSource = KeychainDataSourceImpl(service: "com.yourapp.auth", account: "currentUser")
        self.welcomeRepository = WelcomeRepositoryImpl(keychainDataSource: keychainDataSource)
        self.authenticationRepository = AuthenticationRepository(keychainDataSource: authenticationKeychainDataSource)
        
    }
    
    public func makeAuthenticationRepository() -> AuthenticationRepositoryProtocol {
        return AuthenticationRepository(keychainDataSource: authenticationKeychainDataSource)
    }
    // MARK: - Use Cases
    // WelcomeView
    public func makeGetAllUsersUseCase() -> GetAllUsersUseCaseProtocol {
        return GetAllUsersUseCase(welcomeRepository: welcomeRepository)
    }
    
    public func makeDeleteUserUseCase() -> DeleteUserUseCaseProtocol {
        return DeleteUserUseCase(welcomeRepository: welcomeRepository)
    }
    
    public func makeSignInUseCase() -> CoreUseCases.SignInUseCaseProtocol {
        return SignInUseCase(repository: authenticationRepository)
    }
    
    public func makeSignOutUseCase() -> CoreUseCases.SignOutUseCaseProtocol {
        return SignOutUseCase(repository: authenticationRepository)
    }
    
    public func makeGetSignedInUserUseCase() -> CoreUseCases.GetSignedInUserUseCaseProtocol {
        return GetSignedInUserUseCase(repository: authenticationRepository)
    }
    // AuthenticationView
    public func makeCreateUserUseCase() -> CreateUserUseCaseProtocol {
        return CreateUserUseCase(welcomeRepository: welcomeRepository)
    }
}
