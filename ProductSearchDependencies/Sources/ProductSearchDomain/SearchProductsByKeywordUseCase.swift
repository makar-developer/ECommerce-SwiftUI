//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol
import CoreEntities

public protocol SearchProductsByKeywordUseCaseProtocol {
    func execute(keyword: String) async throws -> [Product]
}

public final class SearchProductsByKeywordUseCase: SearchProductsByKeywordUseCaseProtocol {
    private let repository: ProductSearchRepositoryProtocol

    public init(repository: ProductSearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(keyword: String) async throws -> [Product] {
        return try await repository.searchProducts(by: keyword)
    }
}
