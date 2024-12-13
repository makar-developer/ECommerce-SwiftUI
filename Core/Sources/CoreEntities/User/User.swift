//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//
import Foundation
public struct User: Identifiable, Hashable, Codable {
    public init(name: UserName, login: Login, password: Password, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.login = login
        self.password = password
    }
    
    public let id: UUID
    public let name: UserName
    public let login: Login
    public let password: Password
}


