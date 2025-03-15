//
//  File 3.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreEntities
import Foundation
import ProfileRepositoryProtocol

public protocol UpdateUserNameUseCaseProtocol {
    func execute(newName: String, for userId: UUID) async throws
}

public final class UpdateUserNameUseCase: UpdateUserNameUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(newName: String, for userId: UUID) async throws {
        guard let userName = UserName(rawValue: newName) else {
            throw ProfileUseCaseError.invalidUserName
        }
        try await repository.updateUserName(userName, for: userId)
    }
}
