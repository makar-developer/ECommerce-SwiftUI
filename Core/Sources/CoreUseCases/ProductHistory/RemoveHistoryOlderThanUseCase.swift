//
//  RemoveHistoryOlderThanUseCase.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreRepositories
import Foundation

public protocol RemoveHistoryOlderThanUseCaseProtocol {
    func execute(olderThan date: Date, for userId: UUID) async throws
}

public final class RemoveHistoryOlderThanUseCase: RemoveHistoryOlderThanUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol

    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(olderThan date: Date, for userId: UUID) async throws {
        try await repository.removeHistory(olderThan: date, for: userId)
    }
}
