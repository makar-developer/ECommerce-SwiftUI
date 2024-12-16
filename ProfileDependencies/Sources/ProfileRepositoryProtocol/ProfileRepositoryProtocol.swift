//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation
import CoreEntities

public protocol ProfileRepositoryProtocol {
    func updateUserName(_ name: UserName, for userId: UUID) async throws
    func updateLogin(_ login: Login, for userId: UUID) async throws
    func updatePassword(_ password: Password, for userId: UUID) async throws
    func getUser(by id: UUID) async throws -> User
    func updateProfilePicture(data: Data?, for userId: UUID) async throws
    func getProfilePicture(for userId: UUID) async throws -> Data?
    func deleteProfilePicture(for userId: UUID) async throws
}
