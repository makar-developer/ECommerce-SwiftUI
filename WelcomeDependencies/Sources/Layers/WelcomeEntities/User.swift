//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import Foundation

public struct User: Identifiable, Hashable, Codable {
    public init(name: String, image: String, login: String, password: String) {
            self.id = UUID()
            self.name = name
            self.image = image
        self.login = login
        self.password = password
        }
    
    public let id: UUID
    public let name: String
    public let image: String
    public let login: String
    public let password: String
}	
