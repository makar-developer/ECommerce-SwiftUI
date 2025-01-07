//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import CoreEntities
import CoreRepositories
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
