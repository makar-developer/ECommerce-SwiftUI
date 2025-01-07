//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import Foundation
import CoreEntities
import CoreData
// MARK: - CartEntity Extension

public extension CartEntity {
    func toDomain() -> Cart {
        let products = (self.products?.allObjects as? [CartItemEntity])?
            .compactMap { $0.toDomain() } ?? []
        return Cart(
            products: products,
            id: self.id ?? UUID(),
            userId: self.userData?.id ?? UUID()
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
