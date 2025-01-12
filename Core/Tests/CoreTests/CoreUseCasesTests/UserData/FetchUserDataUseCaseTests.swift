//
//  File 2.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreUseCases
@testable import CoreTestHelpers

final class FetchUserDataUseCaseTests: XCTestCase {
    
    private var sut: FetchUserDataUseCase!
    private var mockRepository: MockUserDataRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserDataRepository()
        sut = FetchUserDataUseCase(userDataRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_CallsFetchUserDataOnRepository_AndReturnsValue() async throws {
        // given
        let user = User.getOneOfThis()
        mockRepository.fetchUserDataReturnValue = user.id
        
        // when
        let result = try await sut.execute(userId: user.id)
        
        // then
        XCTAssertEqual(mockRepository.fetchUserDataCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUserIdForFetch, user.id)
        XCTAssertEqual(result, user.id, "Should return the same UUID from the mock repository")
    }
    
    func testExecute_WhenRepositoryThrowsError_ThrowsError() async {
        // given
        let user = User.getOneOfThis()
        mockRepository.fetchUserDataErrorToThrow = NSError(domain: "TestFetch", code: 202)
        
        // when/then
        do {
            _ = try await sut.execute(userId: user.id)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).domain, "TestFetch")
            XCTAssertEqual((error as NSError).code, 202)
        }
    }
}
