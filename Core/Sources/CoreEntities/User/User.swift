//
//  File.swift
//
//
//  Created by Admin on 17/11/2024.
//
import Foundation

public struct User: Identifiable, Hashable, Codable {
    public init(name: UserName, login: Login, password: Password, profilePicture: String?, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.login = login
        self.password = password
        self.profilePicture = profilePicture
    }

    public let id: UUID
    public let name: UserName
    public let login: Login
    public let password: Password
    public let profilePicture: String?
}
