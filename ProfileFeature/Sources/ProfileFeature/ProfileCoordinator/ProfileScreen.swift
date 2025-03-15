//
//  ProfileScreen.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreEntities

enum ProfileScreen: Identifiable, Hashable {
    case profile
    case changePassword(User)
    case productHistory
    case productDetails(Product)

    var id: String {
        switch self {
        case .profile:
            return "profile"
        case let .changePassword(user):
            return user.id.uuidString
        case .productHistory:
            return "productHistory"
        case let .productDetails(product):
            return String(product.id)
        }
    }
}
