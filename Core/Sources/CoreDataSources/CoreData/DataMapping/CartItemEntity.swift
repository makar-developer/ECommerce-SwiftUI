//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities
import Foundation
public extension CartItemEntity {
    func toCartItem() -> CartItem? {
        guard let productEntity = self.product else { return nil }
        guard let product = productEntity.toProduct() else { return nil }
        return CartItem(product: product, quantity: Int(self.quantity), id: self.id ?? UUID())
    }
}

