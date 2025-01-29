//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import ProductSearchRepositoryProtocol
import CoreDataSources
import ProductSearchEntities
import CoreEntities
import Foundation

public final class ProductSearchRepository: ProductSearchRepositoryProtocol {
    private let networkService: NetworkServiceDataSourceProtocol

    public init(networkService: NetworkServiceDataSourceProtocol) {
        self.networkService = networkService
    }

    public func getAllExistingCategories() async throws -> [CategoryResponse] {
        let endpoint = "/products/categories"
        // Assuming API returns an array of Category objects
        let categories: [CategoryResponse] = try await networkService.request(endpoint: endpoint)
        return categories
    }

    public func searchProducts(by keyword: String) async throws -> [Product] {
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = "/products/search?q=\(query)"
        let response: ProductResponse = try await networkService.request(endpoint: endpoint)
        return response.products
    }

    public func getProducts(fromCategory categorySlug: String) async throws -> [Product] {
        let endpoint = "/products/category/\(categorySlug)"
        let response: ProductResponse = try await networkService.request(endpoint: endpoint)
        return response.products
    }

    public func getCategoryThumbnail(for categorySlug: String) async throws -> String {
        let products = try await getProducts(fromCategory: categorySlug)
        guard let firstProduct = products.first else {
            throw URLError(.badServerResponse)
        }
        return firstProduct.thumbnail
    }
}
