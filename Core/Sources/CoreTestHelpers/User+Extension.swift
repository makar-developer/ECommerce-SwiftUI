//
//  File.swift
//  
//
//  Created by Admin on 06/01/2025.
//

import CoreEntities
import Foundation

public extension User {
    static func getOneOfThis() -> User {
        // Provide "mock" user with fixed fields and a known, consistent ID for reproducible tests
        let name = UserName(rawValue: "JohnDoe")!
        let login = Login(rawValue: "john123")!
        let password = Password(rawValue: "ValidP@ss1")!
        // Using a fixed UUID string for deterministic tests
        let knownID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        return User(name: name, login: login, password: password, profilePicture: nil, id: knownID)
    }
    
    static func getAnArrayOfThese() -> [User] {
        // Provide multiple example Users with known IDs.
        return [
            User(
                name: UserName(rawValue: "Alice")!,
                login: Login(rawValue: "ali123")!,
                password: Password(rawValue: "Alice@123")!,
                profilePicture: nil,
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
            ),
            User(
                name: UserName(rawValue: "Bob")!,
                login: Login(rawValue: "bob456")!,
                password: Password(rawValue: "Bob@4567")!,
                profilePicture: nil,
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
            ),
            User(
                name: UserName(rawValue: "Carol")!,
                login: Login(rawValue: "carol789")!,
                password: Password(rawValue: "Carol@7890")!,
                profilePicture: nil,
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
            )
        ]
    }
}
