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

    public func saveSearchQuery(_ searchQuery: SearchQuery) async {
        var queries = await getAllRecentSearchQueries()

        // Remove if it already exists
        queries.removeAll { $0.query == searchQuery.query }

        // Insert at the beginning
        queries.insert(searchQuery, at: 0)

        // Save back to UserDefaults
        await userDefaultsDataSource.setObject(queries, forKey: key)
    }

    public func getAllRecentSearchQueries() async -> [SearchQuery] {
        let queries: [SearchQuery] = await userDefaultsDataSource.getObject(forKey: key) ?? []
        return queries.sorted(by: { $0.creationDate > $1.creationDate })
    }

    public func removeSearchQuery(_ searchQuery: SearchQuery) async {
        var queries = await getAllRecentSearchQueries()
        queries.removeAll { $0.id == searchQuery.id }
        await userDefaultsDataSource.setObject(queries, forKey: key)
    }

    public func removeAllSearchQueries() async {
        await userDefaultsDataSource.removeObject(forKey: key)
    }
}
