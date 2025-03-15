//
//  SignOutUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class SignOutUseCaseTests: XCTestCase {
    private var mockRepository: MockAuthenticationRepository!
    private var sut: SignOutUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockAuthenticationRepository()
        sut = SignOutUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testSignOut_ClearsUserFromRepository() async throws {
        // given
        let user = User.getOneOfThis()
        // Pre-signin so there's a user
        try await mockRepository.signIn(user: user)

        // when
        try await sut.execute()

        // then
        XCTAssertTrue(mockRepository.didSignOut, "signOut should have been called on repository.")
        XCTAssertNil(mockRepository.storedUser, "User should be cleared from the repository after signOut.")
    }
}
