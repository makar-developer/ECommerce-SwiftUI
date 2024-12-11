//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol
import ProductSearchEntities

public protocol RemoveSearchQueryUseCaseProtocol {
    func execute(searchQuery: SearchQuery)
}

public class RemoveSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(searchQuery: SearchQuery) {
        repository.removeSearchQuery(searchQuery)
    }
}
