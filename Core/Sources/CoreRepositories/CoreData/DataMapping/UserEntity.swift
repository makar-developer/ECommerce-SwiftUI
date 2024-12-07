//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities
import CoreData
// MARK: - UserEntity Extension

extension UserEntity {
    func toUser() -> User? {
        guard let id = self.id,
              let nameString = self.name,
              let loginString = self.login,
              let passwordString = self.password else {
            return nil
        }
        
        guard let name = UserName(nameString),
              let login = Login(loginString),
              let password = Password(passwordString) else {
            return nil
        }
        return User(name: name, image: self.image ?? "", login: login, password: password, id: id)
//        User(
//            id: id,
//            name: name,
//            image: self.image ?? "",
//            login: login,
//            password: password
//        )
    }
    
    func update(from user: User) {
        self.id = user.id
        self.name = user.name.rawValue
        self.image = user.image
        self.login = user.login.rawValue
        self.password = user.password.rawValue
    }
    
    func populate(from user: User) {
        update(from: user)
    }
}

// MARK: - User Extension

extension User {
    func toUserEntity(context: NSManagedObjectContext) -> UserEntity {
        let userEntity = UserEntity(context: context)
        userEntity.populate(from: self)
        return userEntity
    }
}
