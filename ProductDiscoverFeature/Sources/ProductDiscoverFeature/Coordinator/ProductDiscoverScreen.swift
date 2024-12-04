//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import CoreEntities

enum ProductDiscoverScreen: Identifiable, Hashable {
    case productDiscover
    case productDetails(Product, User)
    var id: String {
        switch self {
        case .productDiscover:
            return "productDiscover"
        case .productDetails(let product, _):
            return product.id.description
        }
    }
}
