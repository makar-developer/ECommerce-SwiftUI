//
//  CreateUserUseCaseTests.swift
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

final class CreateUserUseCaseTests: XCTestCase {
    private var sut: CreateUserUseCase!
    private var mockRepository: MockWelcomeRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWelcomeRepository()
        sut = CreateUserUseCase(welcomeRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_ShouldCallSaveUserOnRepository() async throws {
        // given
        let testUser = User.getOneOfThis()

        // when
        try await sut.execute(user: testUser)

        // then
        XCTAssertEqual(mockRepository.saveUserCallCount, 1, "Should call saveUser exactly once")
        XCTAssertTrue(mockRepository.storedUsers.contains(testUser), "The testUser should be added to repository")
    }
}
