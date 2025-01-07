//
//  File.swift
//  
//
//  Created by Admin on 07/01/2025.
//

import CoreEntities
import Foundation

public extension ProductHistory {
    static func getOneOfThis() -> ProductHistory {
        // Create a single instance
        let oneProduct = Product.getOneOfThis()
        return ProductHistory(product: oneProduct)
    }
    
    static func getAnArrayOfThese() -> [ProductHistory] {
        // Create multiple items from Product.getAnArrayOfThese()
        let products = Product.getAnArrayOfThese()
        return products.map { product in
            ProductHistory(product: product, timestamp: Date())
        }
    }
}
