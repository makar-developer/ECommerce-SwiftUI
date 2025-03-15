//
//  File 2.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreRepositories
import Foundation

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

public final class MockDeleteUserDataUseCase: DeleteUserDataUseCaseProtocol {
    public var shouldThrowError = false
    public var deletedUserDataIDs: [UUID] = []

    public init() {}

    public func execute(userId: UUID) async throws {
        if shouldThrowError {
            throw NSError(domain: "DeleteUserDataError", code: 1, userInfo: nil)
        }
        deletedUserDataIDs.append(userId)
    }
}
