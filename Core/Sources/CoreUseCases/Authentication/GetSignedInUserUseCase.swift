//
//  File 2.swift
//  
//
//  Created by Admin on 15/12/2024.
//

import CoreEntities
import CoreRepositories

public protocol GetSignedInUserUseCaseProtocol {
    func execute() async throws -> User?
}

public final class GetSignedInUserUseCase: GetSignedInUserUseCaseProtocol {
    private let repository: AuthenticationRepositoryProtocol

    public init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> User? {
        return try await repository.getSignedInUser()
    }
}
