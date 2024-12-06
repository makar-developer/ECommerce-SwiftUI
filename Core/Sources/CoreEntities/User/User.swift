//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//
import Foundation
public struct User: Identifiable, Hashable, Codable {
    public init(name: UserName, image: String, login: Login, password: Password, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.image = image
        self.login = login
        self.password = password
    }
    
    public let id: UUID
    public let name: UserName
    public let image: String
    public let login: Login
    public let password: Password
}


