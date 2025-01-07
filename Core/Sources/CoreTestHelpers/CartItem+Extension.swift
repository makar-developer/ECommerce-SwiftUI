//
//  File.swift
//  
//
//  Created by Admin on 08/01/2025.
//

import CoreEntities

public extension CartItem {
    static func getOneOfThis() -> CartItem {
        // For a single CartItem, use one product and an arbitrary quantity
        let product = Product.getOneOfThis()
        return CartItem(product: product, quantity: 2)
    }
    
    static func getAnArrayOfThese() -> [CartItem] {
        // For multiple CartItems, use the array of mock products and assign various quantities
        let products = Product.getAnArrayOfThese()
        return [
            CartItem(product: products[0], quantity: 1),
            CartItem(product: products[1], quantity: 2),
            CartItem(product: products[2], quantity: 3)
        ]
    }
}
