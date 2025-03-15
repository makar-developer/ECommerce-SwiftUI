//
//  DeleteUserUseCaseTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreTestHelpers
@testable import WelcomeData
@testable import WelcomeDomain
@testable import WelcomeRepositoryProtocol
import XCTest

final class DeleteUserUseCaseTests: XCTestCase {
    private var sut: DeleteUserUseCase!
    private var mockRepository: MockWelcomeRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWelcomeRepository()
        sut = DeleteUserUseCase(welcomeRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ShouldRemoveUserFromRepository() async throws {
        // given
        // Imagine we start with multiple in-memory users
        let users = User.getAnArrayOfThese()
        mockRepository.storedUsers = users

        // We'll remove one of them
        let userToRemove = users[1]

        // when
        try await sut.execute(user: userToRemove)

        // then
        XCTAssertEqual(mockRepository.deleteCallCount, 1, "Should call delete exactly once")
        XCTAssertFalse(mockRepository.storedUsers.contains(userToRemove), "User should be removed from storedUsers")
    }
}
