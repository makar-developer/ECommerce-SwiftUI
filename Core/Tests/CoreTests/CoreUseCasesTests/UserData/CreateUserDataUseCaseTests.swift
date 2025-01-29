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

final class CreateUserDataUseCaseTests: XCTestCase {
    
    private var sut: CreateUserDataUseCase!
    private var mockRepository: MockUserDataRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserDataRepository()
        sut = CreateUserDataUseCase(userDataRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_CallsCreateUserDataOnRepository() async throws {
        // given
        let user = User.getOneOfThis()
        
        // when
        try await sut.execute(user: user)
        
        // then
        XCTAssertEqual(mockRepository.createUserDataCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUserForCreate, user)
    }
    
    func testExecute_WhenRepositoryThrowsError_ThrowsError() async {
        // given
        let user = User.getOneOfThis()
        mockRepository.createUserDataErrorToThrow = NSError(domain: "Test", code: 99)
        
        // when/then
        do {
            try await sut.execute(user: user)
            XCTFail("Expected error to be thrown")
        } catch {
            // Test passes if we reach here
            XCTAssertEqual((error as NSError).domain, "Test")
            XCTAssertEqual((error as NSError).code, 99)
        }
    }
}
