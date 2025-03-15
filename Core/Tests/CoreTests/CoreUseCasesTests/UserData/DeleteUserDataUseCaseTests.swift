//
//  File 3.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest

final class DeleteUserDataUseCaseTests: XCTestCase {
    private var sut: DeleteUserDataUseCase!
    private var mockRepository: MockUserDataRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserDataRepository()
        sut = DeleteUserDataUseCase(userDataRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_CallsDeleteUserDataOnRepository() async throws {
        // given
        let user = User.getOneOfThis()

        // when
        try await sut.execute(userId: user.id)

        // then
        XCTAssertEqual(mockRepository.deleteUserDataCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUserIdForDelete, user.id)
    }

    func testExecute_WhenRepositoryThrowsError_ThrowsError() async {
        // given
        let user = User.getOneOfThis()
        mockRepository.deleteUserDataErrorToThrow = NSError(domain: "TestDelete", code: 101)

        // when/then
        do {
            try await sut.execute(userId: user.id)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).domain, "TestDelete")
            XCTAssertEqual((error as NSError).code, 101)
        }
    }
}
