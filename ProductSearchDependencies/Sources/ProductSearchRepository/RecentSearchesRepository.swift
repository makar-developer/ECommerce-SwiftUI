//
//  RecentSearchesRepository.swift
//
//
//  Created by Admin on 11/12/2024.
//

import CoreDataSources
import ProductSearchEntities
import ProductSearchRepositoryProtocol

public final class RecentSearchesRepository: RecentSearchesRepositoryProtocol {
    private let userDefaultsDataSource: UserDefaultsDataSourceProtocol
    private let key = "RecentSearchQueries"

    public init(userDefaultsDataSource: UserDefaultsDataSourceProtocol) {
        self.userDefaultsDataSource = userDefaultsDataSource
    }

    public func saveSearchQuery(_ searchQuery: SearchQuery) {
        var queries = getAllRecentSearchQueries()

        // Remove if it already exists
        queries.removeAll { $0.query == searchQuery.query }

        // Insert at the beginning
        queries.insert(searchQuery, at: 0)

        // Save back to UserDefaults
        userDefaultsDataSource.setObject(queries, forKey: key)
    }

    public func getAllRecentSearchQueries() -> [SearchQuery] {
        let queries: [SearchQuery] = userDefaultsDataSource.getObject(forKey: key) ?? []
        return queries.sorted(by: { $0.creationDate > $1.creationDate })
    }

    public func removeSearchQuery(_ searchQuery: SearchQuery) {
        var queries = getAllRecentSearchQueries()
        queries.removeAll { $0.id == searchQuery.id }
        userDefaultsDataSource.setObject(queries, forKey: key)
    }

    public func removeAllSearchQueries() {
        userDefaultsDataSource.removeObject(forKey: key)
    }
}
