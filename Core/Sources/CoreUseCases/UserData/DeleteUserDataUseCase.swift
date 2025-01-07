//
//  File 2.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreRepositories

public protocol DeleteUserDataUseCaseProtocol {
    func execute(userId: UUID) async throws
}

public final class DeleteUserDataUseCase: DeleteUserDataUseCaseProtocol {
    private let userDataRepository: UserDataRepositoryProtocol

    public init(userDataRepository: UserDataRepositoryProtocol) {
        self.userDataRepository = userDataRepository
    }

    public func execute(userId: UUID) async throws {
        try await userDataRepository.deleteUserData(byId: userId)
    }
}
