//
//  File 4.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol

public protocol GetCategoryThumbnailUseCaseProtocol {
    func execute(categorySlug: String) async throws -> String
}

public class GetCategoryThumbnailUseCase: GetCategoryThumbnailUseCaseProtocol {
    private let repository: ProductSearchRepositoryProtocol

    public init(repository: ProductSearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(categorySlug: String) async throws -> String {
        return try await repository.getCategoryThumbnail(for: categorySlug)
    }
}
