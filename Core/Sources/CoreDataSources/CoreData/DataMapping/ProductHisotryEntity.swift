//
//  ProductHisotryEntity.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreData
import CoreEntities
import Foundation

public extension ProductHistoryEntity {
    func toDomain() -> ProductHistory? {
        guard
            let id = id,
            let product = product?.toDomain(),
            let timestamp = timestamp
        else { return nil }

        return ProductHistory(
            id: id,
            product: product,
            timestamp: timestamp
        )
    }
}

public extension ProductHistory {
    func toCoreData(context: NSManagedObjectContext) -> ProductHistoryEntity {
        let entity = ProductHistoryEntity(context: context)
        entity.id = id
        entity.timestamp = timestamp
        // product relationship will be set by repository as needed
        return entity
    }
}
