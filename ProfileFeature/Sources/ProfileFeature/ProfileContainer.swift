//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import ProfileDomain
import ProfileRepositoryProtocol
import ProfileRepository
import CoreRepositories
import CoreUseCases
import CoreDataSources

public protocol ProfileDIContainerProtocol {
    // Use Cases
    func makeUpdateUserNameUseCase() -> UpdateUserNameUseCaseProtocol
    func makeUpdateLoginUseCase() -> UpdateLoginUseCaseProtocol
    func makeUpdatePasswordUseCase() -> UpdatePasswordUseCaseProtocol
    func makeUpdateProfilePictureUseCase() -> UpdateProfilePictureUseCaseProtocol
    func makeGetProfilePictureUseCase() -> GetProfilePictureUseCaseProtocol
    func makeSignOutUseCase() -> SignOutUseCaseProtocol
}

public struct ProfileDIContainerImpl: ProfileDIContainerProtocol {
    
    private var authenticationKeychainDataSource: KeychainDataSourceProtocol
    private var profileRepository: ProfileRepositoryProtocol
    private var authenticationRepository: AuthenticationRepositoryProtocol
    
    public init() {
        self.authenticationKeychainDataSource = KeychainDataSourceImpl(service: "com.yourapp.auth", account: "currentUser")
        self.profileRepository = ProfileRepositoryImpl()
        self.authenticationRepository = AuthenticationRepository(keychainDataSource: authenticationKeychainDataSource)
    }

    // Use Cases
    public func makeSignOutUseCase() -> SignOutUseCaseProtocol {
        SignOutUseCase(repository: authenticationRepository)
    }
    
    public func makeUpdateUserNameUseCase() -> UpdateUserNameUseCaseProtocol {
        UpdateUserNameUseCase(repository: profileRepository)
    }
    
    public func makeUpdateLoginUseCase() -> UpdateLoginUseCaseProtocol {
        UpdateLoginUseCase(repository: profileRepository)
    }
    
    public func makeUpdatePasswordUseCase() -> UpdatePasswordUseCaseProtocol {
        UpdatePasswordUseCase(repository: profileRepository)
    }
    
    public func makeUpdateProfilePictureUseCase() -> UpdateProfilePictureUseCaseProtocol {
        UpdateProfilePictureUseCase(repository: profileRepository)
    }
    
    public func makeGetProfilePictureUseCase() -> GetProfilePictureUseCaseProtocol {
        GetProfilePictureUseCase(repository: profileRepository)
    }
}
