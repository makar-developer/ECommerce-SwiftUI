//
//  File 5.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreUseCases
@testable import CoreTestHelpers

final class RemoveHistoryOlderThanUseCaseTests: XCTestCase {
    
    private var sut: RemoveHistoryOlderThanUseCase!
    private var mockRepository: MockProductHistoryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockProductHistoryRepository()
        sut = RemoveHistoryOlderThanUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_ShouldCallRemoveHistoryOlderThanOnRepository() async throws {
        // given
        let user = User.getOneOfThis()
        let olderThanDate = Date().addingTimeInterval(-10000)
        
        // when
        try await sut.execute(olderThan: olderThanDate, for: user.id)
        
        // then
        XCTAssertEqual(mockRepository.removeHistoryOlderThanCallCount, 1)
        XCTAssertEqual(mockRepository.capturedDate, olderThanDate)
        XCTAssertEqual(mockRepository.capturedUserId, user.id)
    }
}
