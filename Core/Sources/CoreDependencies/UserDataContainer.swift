//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreRepositories
import CoreUseCases
import CoreDataSources
public protocol UserDataDIContainerProtocol {
    // Use Cases
    var createUserDataUseCase: CreateUserDataUseCaseProtocol { get }
    var deleteUserDataUseCase: DeleteUserDataUseCaseProtocol { get }
    var fetchUserDataUseCase: FetchUserDataUseCaseProtocol { get }
    // Repositories
    var userDataRepository: UserDataRepositoryProtocol { get }
}

public final class UserDataDIContainerImpl: UserDataDIContainerProtocol {

    // Core Data Wrapper
    public var coreDataWrapper: CoreDataWrapperProtocol

    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }

    // Repositories
    public lazy var userDataRepository: UserDataRepositoryProtocol = {
        UserDataRepository(coreDataWrapper: coreDataWrapper)
    }()

    // Use Cases

    public lazy var createUserDataUseCase: CreateUserDataUseCaseProtocol = {
        CreateUserDataUseCase(userDataRepository: userDataRepository)
    }()

    public lazy var deleteUserDataUseCase: DeleteUserDataUseCaseProtocol = {
        DeleteUserDataUseCase(userDataRepository: userDataRepository)
    }()
    
    public lazy var fetchUserDataUseCase: FetchUserDataUseCaseProtocol = {
        FetchUserDataUseCase(userDataRepository: userDataRepository)
    }()
}
