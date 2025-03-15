//
//  ProductCartScreen.swift
//
//
//  Created by Admin on 05/12/2024.
//

import CoreEntities
import Foundation

enum ProductCartScreen: Identifiable, Hashable {
    case productCart
    var id: String {
        switch self {
        case .productCart:
            return "productCart"
        }
    }
}
