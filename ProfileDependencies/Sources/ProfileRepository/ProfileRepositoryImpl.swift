//
//  ProfileRepositoryImpl.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreDataSources
import CoreEntities
import Foundation
import ProfileRepositoryProtocol

public final class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let keychainDataSource: KeychainDataSourceProtocol
    private let fileStorageDataSource: FileStorageDataSourceProtocol
    private let profilePictureFileNamePrefix = "profile_picture_"
    private let usersKey = "users"

    public init(
        // Ideally the same instance should be received from DI, since keychainDataSource is used in both ProfileFeature and WelcomeFeature, but it should be fine here since it connects to the same account(source of truth).
        keychainDataSource: KeychainDataSourceProtocol = KeychainDataSourceImpl(service: "com.yourapp.welcome", account: "users"),
        fileStorageDataSource: FileStorageDataSourceProtocol = FileStorageDataSourceImpl()
    ) {
        self.keychainDataSource = keychainDataSource
        self.fileStorageDataSource = fileStorageDataSource
    }

    public func updateUserName(_ name: UserName, for userId: UUID) async throws {
        var users = try await getUsers()
        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            throw ProfileError.userNotFound
        }
        let user = users[index]
        let updatedUser = User(
            name: name,
            login: user.login,
            password: user.password,
            profilePicture: user.profilePicture,
            id: user.id
        )
        users[index] = updatedUser
        try await saveUsers(users)
    }

    public func updateLogin(_ login: Login, for userId: UUID) async throws {
        var users = try await getUsers()
        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            throw ProfileError.userNotFound
        }
        let user = users[index]
        let updatedUser = User(
            name: user.name,
            login: login,
            password: user.password,
            profilePicture: user.profilePicture,
            id: user.id
        )
        users[index] = updatedUser
        try await saveUsers(users)
    }

    public func updatePassword(_ password: Password, for userId: UUID) async throws {
        var users = try await getUsers()
        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            throw ProfileError.userNotFound
        }
        let user = users[index]
        let updatedUser = User(
            name: user.name,
            login: user.login,
            password: password,
            profilePicture: user.profilePicture,
            id: user.id
        )
        users[index] = updatedUser
        try await saveUsers(users)
    }

    public func getUser(by id: UUID) async throws -> User {
        let users = try await getUsers()
        guard let user = users.first(where: { $0.id == id }) else {
            throw ProfileError.userNotFound
        }
        return user
    }

    public func updateProfilePicture(data: Data?, for userId: UUID) async throws {
        let fileName = fileNameForProfilePicture(userId: userId)
        if let data = data {
            try fileStorageDataSource.save(data: data, to: .documentDirectory, with: fileName)
        } else {
            try await deleteProfilePicture(for: userId)
        }
    }

    public func getProfilePicture(for userId: UUID) async throws -> Data? {
        let fileName = fileNameForProfilePicture(userId: userId)
        do {
            let data = try fileStorageDataSource.load(from: .documentDirectory, with: fileName)
            return data
        } catch {
            if let error = error as? FileStorageError, error == .directoryNotFound {
                return nil
            } else if (error as NSError).code == NSFileReadNoSuchFileError {
                return nil
            } else {
                throw error
            }
        }
    }

    public func deleteProfilePicture(for userId: UUID) async throws {
        let fileName = fileNameForProfilePicture(userId: userId)
        do {
            try fileStorageDataSource.delete(from: .documentDirectory, with: fileName)
        } catch {
            if let error = error as? FileStorageError, error == .directoryNotFound {
                // File not found, nothing to delete
            } else if (error as NSError).code != NSFileNoSuchFileError {
                throw error
            }
        }
    }

    // MARK: - Private Helpers

    private func getUsers() async throws -> [User] {
        guard let data = try keychainDataSource.load() else {
            return [] // No users found
        }
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }

    private func saveUsers(_ users: [User]) async throws {
        let data = try JSONEncoder().encode(users)
        try keychainDataSource.save(data: data)
    }

    private func fileNameForProfilePicture(userId: UUID) -> String {
        return "\(profilePictureFileNamePrefix)\(userId.uuidString).png"
    }
}

public enum ProfileError: Error {
    case userNotFound
}
