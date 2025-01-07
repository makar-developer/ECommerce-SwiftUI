//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol

public protocol RemoveAllSearchQueriesUseCaseProtocol {
    func execute()
}

public final class RemoveAllSearchQueriesUseCase: RemoveAllSearchQueriesUseCaseProtocol {
    private let repository: RecentSearchesRepositoryProtocol

    public init(repository: RecentSearchesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() {
        repository.removeAllSearchQueries()
    }
}
