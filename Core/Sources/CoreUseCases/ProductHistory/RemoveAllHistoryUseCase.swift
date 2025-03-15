//
//  RemoveAllHistoryUseCase.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreRepositories
import Foundation

public protocol RemoveAllHistoryUseCaseProtocol {
    func execute(for userId: UUID) async throws
}

public final class RemoveAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol

    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(for userId: UUID) async throws {
        try await repository.removeAllHistory(for: userId)
    }
}
