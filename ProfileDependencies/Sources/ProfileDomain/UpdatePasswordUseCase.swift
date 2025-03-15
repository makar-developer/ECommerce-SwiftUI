//
//  File 3.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreEntities
import Foundation
import ProfileRepositoryProtocol

public protocol UpdatePasswordUseCaseProtocol {
    func execute(newPassword: String, for userId: UUID) async throws
}

public final class UpdatePasswordUseCase: UpdatePasswordUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(newPassword: String, for userId: UUID) async throws {
        guard let password = Password(rawValue: newPassword) else {
            throw ProfileUseCaseError.invalidPassword
        }
        try await repository.updatePassword(password, for: userId)
    }
}
