//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import CoreEntities
import CoreRepositories
import Foundation
public protocol CreateUserDataUseCaseProtocol {
    func execute(user: User) async throws
}

public final class CreateUserDataUseCase: CreateUserDataUseCaseProtocol {
    private let userDataRepository: UserDataRepositoryProtocol

    public init(userDataRepository: UserDataRepositoryProtocol) {
        self.userDataRepository = userDataRepository
    }

    public func execute(user: User) async throws {
        try await userDataRepository.createUserData(user)
    }
}

public final class MockCreateUserDataUseCase: CreateUserDataUseCaseProtocol {
    public var shouldThrowError = false
    public var createdUsersDataIDs: [UUID] = []

    public init() {}
    
    public func execute(user: User) async throws {
        if shouldThrowError {
            throw NSError(domain: "CreateUserDataError", code: 1, userInfo: nil)
        }
        createdUsersDataIDs.append(user.id)
    }
}
