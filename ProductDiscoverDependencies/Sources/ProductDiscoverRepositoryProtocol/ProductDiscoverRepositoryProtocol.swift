//
//  ProductDiscoverRepositoryProtocol.swift
//
//
//  Created by Admin on 02/12/2024.
//

import CoreEntities

public protocol ProductDiscoverRepositoryProtocol {
    func getHotSales() async throws -> [Product]
    func getRecommendedForYou(page: Int) async throws -> [Product]
}
