//
//  File 3.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import ProfileRepositoryProtocol
public protocol DeleteProfilePictureUseCaseProtocol {
    func execute(for userId: UUID) async throws
}


public final class DeleteProfilePictureUseCase: DeleteProfilePictureUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(for userId: UUID) async throws {
        try await repository.deleteProfilePicture(for: userId)
    }
}
