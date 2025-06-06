//
//  RemoveSearchQueryUseCase.swift
//
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol

public protocol RemoveSearchQueryUseCaseProtocol {
    func execute(searchQuery: SearchQuery) async
}

public final class RemoveSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(searchQuery: SearchQuery) async {
        await repository.removeSearchQuery(searchQuery)
    }
}
