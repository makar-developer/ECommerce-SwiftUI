//
//  CartItemEntity.swift
//
//
//  Created by Admin on 04/12/2024.
//

import CoreData
import CoreEntities
import Foundation

public extension CartItemEntity {
    func toDomain() -> CartItem? {
        guard
            let product = product?.toDomain()
        else { return nil }

        return CartItem(
            product: product,
            quantity: Int(quantity),
            id: id ?? UUID()
        )
    }
}

public extension CartItem {
    func toCoreData(context: NSManagedObjectContext) -> CartItemEntity {
        let entity = CartItemEntity(context: context)
        entity.id = id
        entity.quantity = Int16(quantity)
        return entity
    }
}
