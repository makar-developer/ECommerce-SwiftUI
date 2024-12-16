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
public protocol ProfileDIContainerProtocol {
    // Use Cases
    var updateUserNameUseCase: UpdateUserNameUseCaseProtocol { get }
    var updateLoginUseCase: UpdateLoginUseCaseProtocol { get }
    var updatePasswordUseCase: UpdatePasswordUseCaseProtocol { get }
    var updateProfilePictureUseCase: UpdateProfilePictureUseCaseProtocol { get }
    var getProfilePictureUseCase: GetProfilePictureUseCaseProtocol { get }
    var signOutUseCase: SignOutUseCaseProtocol { get }
    // Repositories
    var profileRepository: ProfileRepositoryProtocol { get }
    var authenticationRepository: AuthenticationRepositoryProtocol { get }
    
}

public class ProfileDIContainerImpl: ProfileDIContainerProtocol {
    
    
    // Repositories
    
    public lazy var authenticationRepository: CoreRepositories.AuthenticationRepositoryProtocol = {
       AuthenticationRepository()
    }()
    
    public lazy var profileRepository: ProfileRepositoryProtocol = {
        return ProfileRepositoryImpl()
    }()
    // Use Cases
    
    public lazy var signOutUseCase: CoreUseCases.SignOutUseCaseProtocol = {
        SignOutUseCase(repository: authenticationRepository)
    }()
    
    public lazy var updateUserNameUseCase: UpdateUserNameUseCaseProtocol = {
        return UpdateUserNameUseCase(repository: profileRepository)
    }()

    public lazy var updateLoginUseCase: UpdateLoginUseCaseProtocol = {
        return UpdateLoginUseCase(repository: profileRepository)
    }()

    public lazy var updatePasswordUseCase: UpdatePasswordUseCaseProtocol = {
        return UpdatePasswordUseCase(repository: profileRepository)
    }()

    public lazy var updateProfilePictureUseCase: UpdateProfilePictureUseCaseProtocol = {
        return UpdateProfilePictureUseCase(repository: profileRepository)
    }()

    public lazy var getProfilePictureUseCase: GetProfilePictureUseCaseProtocol = {
        return GetProfilePictureUseCase(repository: profileRepository)
    }()

    // Initialization
    public init() {}
}
