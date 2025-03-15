//
//  CartEntity.swift
//
//
//  Created by Admin on 04/12/2024.
//

import CoreData
import CoreEntities
import Foundation

// MARK: - CartEntity Extension

public extension CartEntity {
    func toDomain() -> Cart {
        let products = (self.products?.allObjects as? [CartItemEntity])?
            .compactMap { $0.toDomain() } ?? []
        return Cart(
            products: products,
            id: id ?? UUID(),
            userId: userData?.id ?? UUID()
        )
    }
}

public extension Cart {
    func toCoreData(context: NSManagedObjectContext) -> CartEntity {
        let entity = CartEntity(context: context)
        entity.id = id
        // Relationship userData set by repository as needed.
        return entity
    }
}
