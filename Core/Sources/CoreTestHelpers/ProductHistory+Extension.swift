//
//  ProductHistory+Extension.swift
//
//
//  Created by Admin on 07/01/2025.
//

import CoreEntities
import Foundation

public extension ProductHistory {
    private static let timestamps: [Date] = [
        Date(timeIntervalSince1970: 1_672_531_200), // 2023-01-01 00:00:00 UTC
        Date(timeIntervalSince1970: 1_672_617_600), // 2023-01-02 00:00:00 UTC
        Date(timeIntervalSince1970: 1_672_704_000), // 2023-01-03 00:00:00 UTC
    ]

    static func getOneOfThis() -> ProductHistory {
        let product = Product.getOneOfThis()
        return ProductHistory(product: product, timestamp: timestamps[0])
    }

    static func getAnArrayOfThese() -> [ProductHistory] {
        // Create multiple ProductHistory objects, each with a different timestamp.
        let products = Product.getAnArrayOfThese()
        guard !products.isEmpty else { return [] }

        // Match each product with a distinct timestamp, cycling if there are more products than timestamps.
        var histories: [ProductHistory] = []

        for (index, product) in products.enumerated() {
            let timestamp = timestamps[index % timestamps.count]
            histories.append(ProductHistory(product: product, timestamp: timestamp))
        }

        return histories
    }
}
