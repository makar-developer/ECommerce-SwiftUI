//
//  UserDataContainer.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreDataSources
import CoreRepositories
import CoreUseCases
import Foundation

public protocol UserDataDIContainerProtocol {
    func makeCreateUserDataUseCase() -> CreateUserDataUseCaseProtocol
    func makeDeleteUserDataUseCase() -> DeleteUserDataUseCaseProtocol
    func makeFetchUserDataUseCase() -> FetchUserDataUseCaseProtocol
}

public struct UserDataDIContainerImpl: UserDataDIContainerProtocol {
    private let coreDataDataSource: CoreDataDataSourceProtocol
    private let userDataRepository: UserDataRepositoryProtocol

    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource

        userDataRepository = UserDataRepository(coreDataDataSource: coreDataDataSource)
    }

    public func makeCreateUserDataUseCase() -> CreateUserDataUseCaseProtocol {
        return CreateUserDataUseCase(userDataRepository: userDataRepository)
    }

    public func makeDeleteUserDataUseCase() -> DeleteUserDataUseCaseProtocol {
        return DeleteUserDataUseCase(userDataRepository: userDataRepository)
    }

    public func makeFetchUserDataUseCase() -> FetchUserDataUseCaseProtocol {
        return FetchUserDataUseCase(userDataRepository: userDataRepository)
    }
}
