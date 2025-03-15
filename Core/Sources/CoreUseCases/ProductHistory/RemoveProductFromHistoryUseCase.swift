//
//  RemoveProductFromHistoryUseCase.swift
//
//
//  Created by Admin on 18/12/2024.
//

import CoreEntities
import CoreRepositories
import Foundation

public protocol RemoveProductFromHistoryUseCaseProtocol {
    func execute(product: Product, for userId: UUID) async throws
}

public final class RemoveProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol

    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(product: Product, for userId: UUID) async throws {
        try await repository.removeProductHistory(product, for: userId)
    }
}
