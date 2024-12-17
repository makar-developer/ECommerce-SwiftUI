//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import CoreEntities
import CoreData
public extension ProductHistoryEntity {
    func toDomainModel() -> ProductHistory? {
        guard let id = self.id,
              let product = self.product?.toProduct(),
              let timestamp = self.timestamp else { return nil }
              
        
        
        return ProductHistory(
            id: id,
            product: product,
            timestamp: timestamp
        )
    }
}


public extension ProductHistory {
    func toCoreDataEntity(context: NSManagedObjectContext) -> ProductHistoryEntity {
        let entity = ProductHistoryEntity(context: context)
        entity.id = self.id
        entity.timestamp = self.timestamp
        // product relationship will be set when saving
        return entity
    }
}
