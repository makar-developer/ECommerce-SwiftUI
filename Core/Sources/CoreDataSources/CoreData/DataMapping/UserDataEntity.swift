//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//


import CoreEntities
import CoreData
// MARK: - UserDataEntity Extension

public extension UserDataEntity {

    func update(from user: User) {
        self.id = user.id
    }
    func populate(from user: User) {
        update(from: user)
    }
}

// MARK: - User Extension

public extension User {
    func toUserDataEntity(context: NSManagedObjectContext) -> UserDataEntity {
        let userDataEntity = UserDataEntity(context: context)
        userDataEntity.populate(from: self)
        return userDataEntity
    }
}

