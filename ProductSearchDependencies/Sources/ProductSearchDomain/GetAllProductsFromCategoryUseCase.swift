//
//  File 5.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import CoreEntities
import ProductSearchRepositoryProtocol
public protocol GetAllProductsFromCategoryUseCaseProtocol {
    func execute(categorySlug: String) async throws -> [Product]
}

public class GetAllProductsFromCategoryUseCase: GetAllProductsFromCategoryUseCaseProtocol {
    private let repository: ProductSearchRepositoryProtocol

    public init(repository: ProductSearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(categorySlug: String) async throws -> [Product] {
        return try await repository.getProducts(fromCategory: categorySlug)
    }
}
