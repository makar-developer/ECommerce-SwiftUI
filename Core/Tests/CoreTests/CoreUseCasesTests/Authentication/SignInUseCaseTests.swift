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

final class SignInUseCaseTests: XCTestCase {
    
    private var mockRepository: MockAuthenticationRepository!
    private var sut: SignInUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockAuthenticationRepository()
        sut = SignInUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testSignIn_SavesUserInRepository() async throws {
        // given
        let user = User.getOneOfThis()
        
        // when
        try await sut.execute(user: user)
        
        // then
        XCTAssertTrue(mockRepository.didSignIn, "signIn should have been called on repository.")
        XCTAssertEqual(mockRepository.storedUser?.id, user.id, "The stored user should match the user who signed in.")
    }
}
