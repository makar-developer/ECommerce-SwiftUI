//
//  GetRecommendedForYouUseCase.swift
//
//
//  Created by Admin on 02/12/2024.
//

import CoreEntities
import ProductDiscoverRepositoryProtocol

public protocol GetRecommendedForYouUseCaseProtocol {
    func execute(page: Int) async throws -> [Product]
}

public final class GetRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol {
    private let repository: ProductDiscoverRepositoryProtocol

    public init(repository: ProductDiscoverRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> [Product] {
        return try await repository.getRecommendedForYou(page: page)
    }
}
