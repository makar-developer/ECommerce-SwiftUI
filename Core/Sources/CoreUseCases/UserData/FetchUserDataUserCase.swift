//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreRepositories
public protocol FetchUserDataUseCaseProtocol {
    func execute(userId: UUID) async throws -> UUID?
}

public final class FetchUserDataUseCase: FetchUserDataUseCaseProtocol {
    private let userDataRepository: UserDataRepositoryProtocol

    public init(userDataRepository: UserDataRepositoryProtocol) {
        self.userDataRepository = userDataRepository
    }

    public func execute(userId: UUID) async throws -> UUID? {
        try await userDataRepository.fetchUserData(byId: userId)
    }
}
