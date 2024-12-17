//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import Foundation
import CoreEntities
// MARK: - CartEntity Extension

public extension CartEntity {
    func toCart() -> Cart {
        let products = (self.products?.allObjects as? [CartItemEntity])?.compactMap { $0.toCartItem() } ?? []
        return Cart(products: products, id: self.id ?? UUID(), userId: self.userData?.id ?? UUID())
    }
}
