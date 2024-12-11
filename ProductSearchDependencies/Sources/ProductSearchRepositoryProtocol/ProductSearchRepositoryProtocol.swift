//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import CoreEntities
import ProductSearchEntities

public protocol ProductSearchRepositoryProtocol {
    func getAllExistingCategories() async throws -> [CategoryResponse]
    func searchProducts(by keyword: String) async throws -> [Product]
    func getProducts(fromCategory categorySlug: String) async throws -> [Product]
    func getCategoryThumbnail(for categorySlug: String) async throws -> String
}
