//
//  File 4.swift
//
//
//  Created by Admin on 12/01/2025.
//
import XCTest

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases

final class GetSignedInUserUseCaseTests: XCTestCase {
    private var mockRepository: MockAuthenticationRepository!
    private var sut: GetSignedInUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockAuthenticationRepository()
        sut = GetSignedInUserUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ReturnsNilWhenNoUserSignedIn() async throws {
        // given
        // No user is signed in by default (storedUser == nil)

        // when
        let currentUser = try await sut.execute()

        // then
        XCTAssertTrue(mockRepository.didGetSignedInUser, "getSignedInUser should have been called on repository.")
        XCTAssertNil(currentUser, "Expected nil if no user was signed in.")
    }

    func testExecute_ReturnsUserWhenSignedIn() async throws {
        // given
        let user = User.getOneOfThis()
        try await mockRepository.signIn(user: user)

        // when
        let currentUser = try await sut.execute()

        // then
        XCTAssertTrue(mockRepository.didGetSignedInUser, "getSignedInUser should have been called on repository.")
        XCTAssertNotNil(currentUser, "Expected a user if one was previously signed in.")
        XCTAssertEqual(currentUser?.id, user.id, "Expected the user's ID to match what was signed in.")
    }
}
