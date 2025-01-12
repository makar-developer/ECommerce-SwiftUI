//
//  File 3.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreUseCases
@testable import CoreTestHelpers

final class GetProductHistoryUseCaseTests: XCTestCase {
    
    private var sut: GetProductHistoryUseCase!
    private var mockRepository: MockProductHistoryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockProductHistoryRepository()
        sut = GetProductHistoryUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_ShouldReturnHistoryFromRepository() async throws {
        // given
        let user = User.getOneOfThis()
        let histories = ProductHistory.getAnArrayOfThese()
        
        // Prepare mock to return the array
        mockRepository.getAllHistoryReturnValue = histories
        
        // when
        let result = try await sut.execute(for: user.id)
        
        // then
        XCTAssertEqual(mockRepository.getAllHistoryCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUserId, user.id)
        XCTAssertEqual(result, histories, "Should return the same histories from the mock.")
    }
}
