//
//  File 3.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import ProfileRepositoryProtocol
import CoreEntities

public protocol UpdateLoginUseCaseProtocol {
    func execute(newLogin: String, for userId: UUID) async throws
}

public final class UpdateLoginUseCase: UpdateLoginUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(newLogin: String, for userId: UUID) async throws {
        guard let login = Login(rawValue: newLogin) else {
            throw ProfileUseCaseError.invalidLogin
        }
        try await repository.updateLogin(login, for: userId)
    }
}
