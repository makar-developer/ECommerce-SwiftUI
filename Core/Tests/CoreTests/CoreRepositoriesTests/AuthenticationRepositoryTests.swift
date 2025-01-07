//
//  File.swift
//  
//
//  Created by Admin on 06/01/2025.
//


import XCTest
@testable import CoreEntities
@testable import CoreDataSources
@testable import CoreRepositories
@testable import CoreTestHelpers

final class AuthenticationRepositoryTests: XCTestCase {

    func testSignInSavesUserData() async throws {
        // given
        let mockKeychain = MockKeychainWrapper()
        let sut = AuthenticationRepository(keychainWrapper: mockKeychain)
        let user = User.getOneOfThis()  // ← Use your existing "getOneOfThis()" method

        // when
        try await sut.signIn(user: user)

        // then
        XCTAssertTrue(mockKeychain.didCallSave, "Expected keychain save to be called")
        let data = mockKeychain.storedData
        XCTAssertNotNil(data, "Expected data to be stored in mock keychain")

        // Verify the data is the correct user
        if let stored = data {
            let decodedUser = try JSONDecoder().decode(User.self, from: stored)
            XCTAssertEqual(decodedUser.id, user.id, "Expected stored user to match original user")
        }
    }

    func testGetSignedInUserReturnsStoredUser() async throws {
        // given
        let mockKeychain = MockKeychainWrapper()
        let sut = AuthenticationRepository(keychainWrapper: mockKeychain)
        let user = User.getOneOfThis()
        try await sut.signIn(user: user)  // Preload keychain

        // when
        let loadedUser = try await sut.getSignedInUser()

        // then
        XCTAssertTrue(mockKeychain.didCallLoad, "Expected keychain load to be called")
        XCTAssertNotNil(loadedUser, "Expected a stored user to be returned")
        XCTAssertEqual(loadedUser?.id, user.id, "Expected loaded user to match the one we stored")
    }

    func testGetSignedInUserReturnsNilIfNoData() async throws {
        // given
        let mockKeychain = MockKeychainWrapper()
        let sut = AuthenticationRepository(keychainWrapper: mockKeychain)

        // when
        let loadedUser = try await sut.getSignedInUser()

        // then
        XCTAssertTrue(mockKeychain.didCallLoad, "Expected keychain load to be called")
        XCTAssertNil(loadedUser, "Expected nil if no user data is present in keychain")
    }

    func testSignOutDeletesUserData() async throws {
        // given
        let mockKeychain = MockKeychainWrapper()
        let sut = AuthenticationRepository(keychainWrapper: mockKeychain)
        let user = User.getOneOfThis()
        try await sut.signIn(user: user)

        // when
        try await sut.signOut()

        // then
        XCTAssertTrue(mockKeychain.didCallDelete, "Expected keychain delete to be called")
        XCTAssertNil(mockKeychain.storedData, "Expected storedData to be nil after signOut")
    }
}
