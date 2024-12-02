//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import Foundation
import CoreEntities
import ProductDiscoverRepositoryProtocol

public final class ProductDiscoverRepositoryImpl: ProductDiscoverRepositoryProtocol {
    private let baseURL = "https://dummyjson.com/products"

    public init() {}

    public func getHotSales() async throws -> [Product] {
        let urlString = "\(baseURL)?limit=10"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
        return productResponse.products
    }

    public func getRecommendedForYou(page: Int) async throws -> [Product] {
        let limit = 5
        let skip = (page - 1) * limit
        let urlString = "\(baseURL)?limit=\(limit)&skip=\(skip)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
        return productResponse.products
    }
}
