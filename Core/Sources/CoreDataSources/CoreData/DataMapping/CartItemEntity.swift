//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities
import Foundation
import CoreData

public extension CartItemEntity {
    func toDomain() -> CartItem? {
        guard
            let product = product?.toDomain()
        else { return nil }
        
        return CartItem(
            product: product,
            quantity: Int(self.quantity),
            id: self.id ?? UUID()
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
