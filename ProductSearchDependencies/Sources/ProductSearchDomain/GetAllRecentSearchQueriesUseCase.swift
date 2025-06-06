//
//  File 2.swift
//
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities
import ProductSearchRepositoryProtocol

public protocol GetAllRecentSearchQueriesUseCaseProtocol {
    func execute() async -> [SearchQuery]
}

public final class GetAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> [SearchQuery] {
        return await repository.getAllRecentSearchQueries()
    }
}
