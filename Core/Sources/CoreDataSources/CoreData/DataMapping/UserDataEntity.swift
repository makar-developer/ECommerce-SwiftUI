//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//


import CoreEntities
import CoreData

public extension User {
    func toCoreData(context: NSManagedObjectContext) -> UserDataEntity {
        let entity = UserDataEntity(context: context)
        entity.id = self.id
        // Additional fields as needed
        return entity
    }
}
