//
//  File 2.swift
//
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol

public protocol GetAllRecentSearchQueriesUseCaseProtocol {
    func execute() -> [SearchQuery]
}

public final class GetAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> [SearchQuery] {
        return repository.getAllRecentSearchQueries()
    }
}
