//
//  File 2.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol
import ProductSearchEntities

public protocol GetAllRecentSearchQueriesUseCaseProtocol {
    func execute() -> [SearchQuery]
}

public class GetAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> [SearchQuery] {
        return repository.getAllRecentSearchQueries()
    }
}
