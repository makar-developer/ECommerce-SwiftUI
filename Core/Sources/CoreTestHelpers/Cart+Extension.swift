//
//  File.swift
//  
//
//  Created by Admin on 08/01/2025.
//

import CoreEntities
import Foundation

extension Cart {
    static func getOneOfThis() -> Cart {
        // Create a single Cart using one CartItem
        let cartItem = CartItem.getOneOfThis()
        return Cart(products: [cartItem], userId: UUID())
    }
}


