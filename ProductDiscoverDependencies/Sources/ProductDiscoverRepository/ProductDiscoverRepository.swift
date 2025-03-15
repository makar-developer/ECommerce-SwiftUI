//
//  ProductDiscoverRepository.swift
//
//
//  Created by Admin on 02/12/2024.
//

import CoreDataSources
import CoreEntities
import Foundation
import ProductDiscoverRepositoryProtocol

public final class ProductDiscoverRepositoryImpl: ProductDiscoverRepositoryProtocol {
    private let networkService: NetworkServiceDataSourceProtocol

    public init(networkService: NetworkServiceDataSourceProtocol) {
        self.networkService = networkService
    }

    public func getHotSales() async throws -> [Product] {
        let endpoint = "?limit=10"
        let productResponse: ProductResponse = try await networkService.request(endpoint: endpoint)
        return productResponse.products
    }

    public func getRecommendedForYou(page: Int) async throws -> [Product] {
        let limit = 10
        let skip = (page - 1) * limit
        let endpoint = "?limit=\(limit)&skip=\(skip)"
        let productResponse: ProductResponse = try await networkService.request(endpoint: endpoint)
        return productResponse.products
    }
}
