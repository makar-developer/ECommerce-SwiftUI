//
//  GetHotSalesUseCase.swift
//
//
//  Created by Admin on 02/12/2024.
//

import CoreEntities
import ProductDiscoverRepositoryProtocol

public protocol GetHotSalesUseCaseProtocol {
    func execute() async throws -> [Product]
}

public final class GetHotSalesUseCase: GetHotSalesUseCaseProtocol {
    private let repository: ProductDiscoverRepositoryProtocol

    public init(repository: ProductDiscoverRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Product] {
        return try await repository.getHotSales()
    }
}
