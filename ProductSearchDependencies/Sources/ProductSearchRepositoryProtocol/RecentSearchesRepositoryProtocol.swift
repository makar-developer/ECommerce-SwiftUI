//
//  RecentSearchesRepositoryProtocol.swift
//
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchEntities

public protocol RecentSearchesRepositoryProtocol {
    func saveSearchQuery(_ searchQuery: SearchQuery) async
    func getAllRecentSearchQueries() async -> [SearchQuery] 
    func removeSearchQuery(_ searchQuery: SearchQuery) async
    func removeAllSearchQueries() async
}
