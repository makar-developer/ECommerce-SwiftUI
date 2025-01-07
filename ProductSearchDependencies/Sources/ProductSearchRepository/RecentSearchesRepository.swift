//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//


import ProductSearchRepositoryProtocol
import CoreDataSources
import ProductSearchEntities

public final class RecentSearchesRepository: RecentSearchesRepositoryProtocol {
    private let userDefaultsWrapper: UserDefaultsWrapperProtocol
    private let key = "RecentSearchQueries"

    public init(userDefaultsWrapper: UserDefaultsWrapperProtocol) {
        self.userDefaultsWrapper = userDefaultsWrapper
    }

    public func saveSearchQuery(_ searchQuery: SearchQuery) {
        var queries = getAllRecentSearchQueries()

        // Remove if it already exists
        queries.removeAll { $0.query == searchQuery.query }

        // Insert at the beginning
        queries.insert(searchQuery, at: 0)

        // Save back to UserDefaults
        userDefaultsWrapper.setObject(queries, forKey: key)
    }

    public func getAllRecentSearchQueries() -> [SearchQuery] {
        let queries: [SearchQuery] = userDefaultsWrapper.getObject(forKey: key) ?? []
        return queries.sorted(by: { $0.creationDate > $1.creationDate })
    }

    public func removeSearchQuery(_ searchQuery: SearchQuery) {
        var queries = getAllRecentSearchQueries()
        queries.removeAll { $0.id == searchQuery.id }
        userDefaultsWrapper.setObject(queries, forKey: key)
    }

    public func removeAllSearchQueries() {
        userDefaultsWrapper.removeObject(forKey: key)
    }
}
