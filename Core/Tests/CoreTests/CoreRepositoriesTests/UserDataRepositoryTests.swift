//
//  File.swift
//  
//
//  Created by Admin on 08/01/2025.
//

import XCTest
@testable import CoreDataSources
@testable import CoreEntities
@testable import CoreRepositories

final class UserDataRepositoryTests: XCTestCase {
    
    private var sut: UserDataRepository!
    private var mockCoreDataWrapper: MockCoreDataWrapper!
    
    override func setUp() {
        super.setUp()
        mockCoreDataWrapper = MockCoreDataWrapper(modelName: "UserData")
        sut = UserDataRepository(coreDataWrapper: mockCoreDataWrapper)
    }
    
    override func tearDown() {
        sut = nil
        mockCoreDataWrapper = nil
        super.tearDown()
    }
    
    func test_createUserData_whenUserDoesNotExist_succeeds() async throws {
        // given
        let user = User.getOneOfThis()
        
        // when
        try await sut.createUserData(user)
        
        // then
        let fetchedID = try await sut.fetchUserData(byId: user.id)
        XCTAssertEqual(fetchedID, user.id, "Expected to fetch the same user ID that was just created.")
    }
    
    func test_createUserData_whenUserAlreadyExists_throwsError() async throws {
        // given
        let user = User.getOneOfThis()
        try await sut.createUserData(user)  // first creation
        
        // when
        do {
            try await sut.createUserData(user)  // attempt creation again
            XCTFail("Expected error when creating the same user again")
        } catch {
            // then
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "UserDataRepository")
            XCTAssertEqual(nsError.code, 1, "Expecting code=1 for 'already exists' error.")
        }
    }
    
    func test_deleteUserData_whenUserExists_succeeds() async throws {
        // given
        let user = User.getOneOfThis()
        try await sut.createUserData(user)
        
        // when
        try await sut.deleteUserData(byId: user.id)
        
        // then
        let fetchedID = try await sut.fetchUserData(byId: user.id)
        XCTAssertNil(fetchedID, "Expected user to have been deleted.")
    }
    
    func test_deleteUserData_whenUserDoesNotExist_throwsError() async throws {
        // given
        let nonExistingID = UUID(uuidString: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF")!
        
        // when
        do {
            try await sut.deleteUserData(byId: nonExistingID)
            XCTFail("Expected not found error")
        } catch {
            // then
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "UserDataRepository")
            XCTAssertEqual(nsError.code, 404, "Expecting code=404 for 'not found' error.")
        }
    }
    
    func test_fetchUserData_whenUserDoesNotExist_returnsNil() async throws {
        // given
        let nonExistingID = UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!
        
        // when
        let fetchedID = try await sut.fetchUserData(byId: nonExistingID)
        
        // then
        XCTAssertNil(fetchedID, "Expected nil if user does not exist.")
    }
}


