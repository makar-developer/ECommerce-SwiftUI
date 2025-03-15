//
//  File 3.swift
//
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import ProfileRepositoryProtocol

public protocol GetProfilePictureUseCaseProtocol {
    func execute(for userId: UUID) async throws -> Data?
}

public final class GetProfilePictureUseCase: GetProfilePictureUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(for userId: UUID) async throws -> Data? {
        return try await repository.getProfilePicture(for: userId)
    }
}
