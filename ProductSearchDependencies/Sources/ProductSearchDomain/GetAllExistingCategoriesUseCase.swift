//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol
public protocol GetAllExistingCategoriesUseCaseProtocol {
    func execute() async throws -> [CategoryResponse]
}

public final class GetAllExistingCategoriesUseCase: GetAllExistingCategoriesUseCaseProtocol {
    private let repository: ProductSearchRepositoryProtocol

    public init(repository: ProductSearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [CategoryResponse] {
        return try await repository.getAllExistingCategories()
    }
}
