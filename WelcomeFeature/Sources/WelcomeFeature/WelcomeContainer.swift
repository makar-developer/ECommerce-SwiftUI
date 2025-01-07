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
    var getAllUsersUseCase: GetAllUsersUseCaseProtocol { get }
    var deleteUserUseCase: DeleteUserUseCaseProtocol { get }
    var createUserUseCase: CreateUserUseCaseProtocol { get }
    var signInUseCase: CoreUseCases.SignInUseCaseProtocol { get }
    var signOutUseCase: CoreUseCases.SignOutUseCaseProtocol { get }
    var getSignedInUserUseCase: CoreUseCases.GetSignedInUserUseCaseProtocol { get }
    // MARK: - Repositories
    var welcomeRepository: WelcomeRepositoryProtocol { get }
    var authenticationRepository: AuthenticationRepositoryProtocol { get }
    // MARK: - DataSources
    var welcomeKeychainWrapper: KeychainWrapperProtocol { get }
    var authenticationKeychainWrapper: KeychainWrapperProtocol { get }

}

public final class WelcomeDIContainerImpl: WelcomeDIContainerProtocol {
    public lazy var welcomeKeychainWrapper: CoreDataSources.KeychainWrapperProtocol = {
        return KeychainWrapperImpl(service: "com.yourapp.welcome", account: "users")
    }()
    
    public lazy var authenticationKeychainWrapper: CoreDataSources.KeychainWrapperProtocol = {
        return KeychainWrapperImpl(service: "com.yourapp.auth", account: "currentUser")
    }()
    
    // MARK: - Repositories
    public lazy var welcomeRepository: WelcomeRepositoryProtocol = {
        return WelcomeRepositoryImpl(keychainWrapper: welcomeKeychainWrapper)
    }()
    
    public lazy var authenticationRepository: AuthenticationRepositoryProtocol = {
        return AuthenticationRepository(keychainWrapper: authenticationKeychainWrapper)
    }()
    // MARK: - Use Cases
    // WelcomeView
    public lazy var getAllUsersUseCase: GetAllUsersUseCaseProtocol = {
        return GetAllUsersUseCase(welcomeRepository: welcomeRepository)
    }()
    
    public lazy var deleteUserUseCase: DeleteUserUseCaseProtocol = {
        return DeleteUserUseCase(welcomeRepository: welcomeRepository)
    }()
    
    public lazy var signInUseCase: CoreUseCases.SignInUseCaseProtocol = {
       return SignInUseCase(repository: authenticationRepository)
    }()
    
    public lazy var signOutUseCase: CoreUseCases.SignOutUseCaseProtocol = {
       return SignOutUseCase(repository: authenticationRepository)
    }()
    
    public lazy var getSignedInUserUseCase: CoreUseCases.GetSignedInUserUseCaseProtocol = {
       return GetSignedInUserUseCase(repository: authenticationRepository)
    }()
    // AuthenticationView
    public lazy var createUserUseCase: CreateUserUseCaseProtocol = {
        return CreateUserUseCase(welcomeRepository: welcomeRepository)
    }()
    
    
    
    public init() {}
}
