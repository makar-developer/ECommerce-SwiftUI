//
//  File 2.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import WelcomeRepositoryProtocol
@testable import WelcomeData
@testable import WelcomeDomain
@testable import CoreEntities
@testable import CoreTestHelpers

final class GetAllUsersUseCaseTests: XCTestCase {
    
    private var sut: GetAllUsersUseCase!
    private var mockRepository: MockWelcomeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWelcomeRepository()
        sut = GetAllUsersUseCase(welcomeRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_ShouldReturnAllUsersFromRepository() async throws {
        // given
        let users = User.getAnArrayOfThese()
        mockRepository.storedUsers = users
        
        // when
        let result = try await sut.execute()
        
        // then
        XCTAssertEqual(mockRepository.getUsersCallCount, 1, "Should call getUsers exactly once")
        XCTAssertEqual(result, users, "Should return the same users that are stored in the mockRepository")
    }
}

