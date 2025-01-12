//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import WelcomeData
@testable import WelcomeDomain
@testable import WelcomePresentation
@testable import CoreEntities
@testable import CoreUseCases
@testable import CoreTestHelpers

@MainActor
final class WelcomeViewModelTests: XCTestCase {

    private var mockGetAllUsersUseCase: MockGetAllUsersUseCase!
    private var mockDeleteUserUseCase: MockDeleteUserUseCase!
    private var mockSignInUseCase: MockSignInUseCase!
    private var mockDeleteUserDataUseCase: MockDeleteUserDataUseCase!
    private var mockCreateUserUseCase: MockCreateUserUseCase!
    private var mockCreateUserDataUseCase: MockCreateUserDataUseCase!
    private var mockFetchUserDataUseCase: MockFetchUserDataUseCase!
    private var sut: WelcomeViewModel!

    override func setUp() {
        super.setUp()
        mockGetAllUsersUseCase = MockGetAllUsersUseCase()
        mockDeleteUserUseCase = MockDeleteUserUseCase()
        mockSignInUseCase = MockSignInUseCase()
        mockDeleteUserDataUseCase = MockDeleteUserDataUseCase()
        mockCreateUserUseCase = MockCreateUserUseCase()
        mockCreateUserDataUseCase = MockCreateUserDataUseCase()
        mockFetchUserDataUseCase = MockFetchUserDataUseCase()

        sut = WelcomeViewModel(
            getAllUsersUseCase: mockGetAllUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase,
            signInUseCase: mockSignInUseCase,
            deleteUserDataUseCase: mockDeleteUserDataUseCase,
            createUserUseCase: mockCreateUserUseCase,
            createUserDataUseCase: mockCreateUserDataUseCase,
            fetchUserDataUseCase: mockFetchUserDataUseCase
        ) { _ in
            // Navigation callback not tested here, can track if needed.
        }
    }

    override func tearDown() {
        sut = nil
        mockGetAllUsersUseCase = nil
        mockDeleteUserUseCase = nil
        mockSignInUseCase = nil
        mockDeleteUserDataUseCase = nil
        mockCreateUserUseCase = nil
        mockCreateUserDataUseCase = nil
        mockFetchUserDataUseCase = nil
        super.tearDown()
    }

    func testLoadUsersSuccessfully() async {
        // given
        let testUsers = User.getAnArrayOfThese()
        mockGetAllUsersUseCase.returnedUsers = testUsers

        // when
        await sut.loadUsers()

        // then
        XCTAssertEqual(sut.users.count, testUsers.count)
        XCTAssertEqual(sut.users, testUsers)
    }

    func testLoadUsersInitialFetchCreatesDefaultUsers() async {
        // given
        UserDefaults.standard.set(false, forKey: "hasFetchedUsersBefore")
        mockGetAllUsersUseCase.returnedUsers = []

        // when
        await sut.loadUsers()

        // then
        XCTAssertEqual(mockCreateUserUseCase.createdUsers.count, 5)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasFetchedUsersBefore"))
    }

    func testLoadUsersEnsuresConsistency() async {
        // given
        let userWithMissingData = User.getOneOfThis()
        mockGetAllUsersUseCase.returnedUsers = [userWithMissingData]
        mockFetchUserDataUseCase.userDataMap[userWithMissingData.id] = nil

        // when
        await sut.loadUsers()

        // then
        XCTAssertEqual(mockCreateUserDataUseCase.createdUsersDataIDs.count, 1)
        XCTAssertEqual(mockCreateUserDataUseCase.createdUsersDataIDs.first, userWithMissingData.id)
    }

    func testDeleteUserSuccessfully() async {
        // given
        let userToDelete = User.getOneOfThis()
        sut.users = [userToDelete]

        // when
        sut.deleteUser(user: userToDelete)
        try? await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // then
        XCTAssertTrue(mockDeleteUserUseCase.deletedUserIDs.contains(userToDelete.id))
        XCTAssertTrue(mockDeleteUserDataUseCase.deletedUserDataIDs.contains(userToDelete.id))
        XCTAssertTrue(sut.users.isEmpty)
    }

    func testDeleteUserHandlesError() async {
        // given
        let userToDelete = User.getOneOfThis()
        sut.users = [userToDelete]
        mockDeleteUserUseCase.shouldThrowError = true

        // when
        sut.deleteUser(user: userToDelete)
        try? await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // then
        XCTAssertFalse(mockDeleteUserDataUseCase.deletedUserDataIDs.contains(userToDelete.id))
        XCTAssertFalse(sut.users.isEmpty)
    }

    func testSignInUserSuccessfully() async {
        // given
        let userToSignIn = User.getOneOfThis()

        // when
        sut.signIn(user: userToSignIn)
        try? await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // then
        XCTAssertTrue(mockSignInUseCase.signedInUserIDs.contains(userToSignIn.id))
    }

    func testSignInUserHandlesError() async {
        // given
        let userToSignIn = User.getOneOfThis()
        mockSignInUseCase.shouldThrowError = true

        // when
        sut.signIn(user: userToSignIn)
        try? await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // then
        XCTAssertFalse(mockSignInUseCase.signedInUserIDs.contains(userToSignIn.id))
    }

    func testToggleEditingMode() {
        // given
        XCTAssertFalse(sut.isEditingModeEnabled)

        // when
        sut.toggleEditingMode()

        // then
        XCTAssertTrue(sut.isEditingModeEnabled)

        // when
        sut.toggleEditingMode()

        // then
        XCTAssertFalse(sut.isEditingModeEnabled)
    }

    func testAssignUniqueImages() async {
        // given
        let testUsers = User.getAnArrayOfThese()
        mockGetAllUsersUseCase.returnedUsers = testUsers

        // when
        await sut.loadUsers()

        // then
        XCTAssertEqual(sut.assignedImages.count, testUsers.count)
        XCTAssertTrue(Set(sut.assignedImages.values).isSubset(of: sut.userCardBackgroundImages))
    }
}

