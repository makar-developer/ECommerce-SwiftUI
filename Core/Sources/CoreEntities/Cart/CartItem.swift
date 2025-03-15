//
//  CartItem.swift
//
//
//  Created by Admin on 02/12/2024.
//

import Foundation

public struct CartItem: Identifiable, Hashable, Codable {
    public let id: UUID
    public let product: Product
    public var quantity: Int

    public init(product: Product, quantity: Int, id: UUID = UUID()) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }

    public static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.id == rhs.id
    }
}
