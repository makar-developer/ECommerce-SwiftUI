//
//  File 3.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import ProfileRepositoryProtocol

public protocol UpdateProfilePictureUseCaseProtocol {
    func execute(data: Data?, for userId: UUID) async throws
}

public class UpdateProfilePictureUseCase: UpdateProfilePictureUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(data: Data?, for userId: UUID) async throws {
        try await repository.updateProfilePicture(data: data, for: userId)
    }
}
