//
//  ProductSearchScreen.swift
//
//
//  Created by Admin on 11/12/2024.
//

import CoreEntities
import Foundation
import ProductSearchEntities

enum ProductSearchScreen: Identifiable, Hashable {
    case productSearch
    case categoryDetails(CategoryResponse, User)
    case productDetails(Product, User)
    var id: String {
        switch self {
        case .productSearch:
            return "productSearch"
        case let .categoryDetails(category, _):
            return category.id.description
        case let .productDetails(product, _):
            return product.id.description
        }
    }
}
