//
//  File 3.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import ProfileRepositoryProtocol
import CoreEntities

public protocol UpdatePasswordUseCaseProtocol {
    func execute(newPassword: String, for userId: UUID) async throws
}

public final class UpdatePasswordUseCase: UpdatePasswordUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(newPassword: String, for userId: UUID) async throws {
        guard let password = Password(newPassword) else {
            throw ProfileUseCaseError.invalidPassword
        }
        try await repository.updatePassword(password, for: userId)
    }
}
