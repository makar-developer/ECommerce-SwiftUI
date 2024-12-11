//
//  File 3.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol

public protocol SaveSearchQueryToRecentsUseCaseProtocol {
    func execute(searchQuery: SearchQuery)
}

public class SaveSearchQueryToRecentsUseCase: SaveSearchQueryToRecentsUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(searchQuery: SearchQuery) {
        repository.saveSearchQuery(searchQuery)
    }
}
