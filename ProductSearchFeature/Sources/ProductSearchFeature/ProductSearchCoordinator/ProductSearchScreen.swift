//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import Foundation
import CoreEntities
import ProductSearchEntities


enum ProductSearchScreen: Identifiable, Hashable {
    case productSearch
    case categoryDetails(CategoryResponse, User)
    case productDetails(Product, User)
    var id: String {
        switch self {
        case .productSearch:
            return "productSearch"
        case .categoryDetails(let category, _):
            return category.id.description
        case .productDetails(let product, _):
            return product.id.description
        }
    }
}
