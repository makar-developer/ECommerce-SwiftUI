//
//  File 3.swift
//
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol

public protocol SaveSearchQueryToRecentsUseCaseProtocol {
    func execute(searchQuery: SearchQuery) async
}

public final class SaveSearchQueryToRecentsUseCase: SaveSearchQueryToRecentsUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(searchQuery: SearchQuery) async {
        await repository.saveSearchQuery(searchQuery)
    }
}
