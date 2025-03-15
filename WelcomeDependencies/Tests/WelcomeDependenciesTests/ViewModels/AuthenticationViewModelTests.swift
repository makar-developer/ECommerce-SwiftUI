//
//  AuthenticationViewModelTests.swift
//
//
//  Created by Admin on 12/01/2025.
//

@testable import CoreEntities
@testable import CoreTestHelpers
@testable import CoreUseCases
@testable import WelcomeData
@testable import WelcomeDomain
@testable import WelcomePresentation
import XCTest

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    private var mockCreateUserUseCase: MockCreateUserUseCase!
    private var mockCreateUserDataUseCase: MockCreateUserDataUseCase!
    private var sut: AuthenticationViewModel!
    private var onNavigationCalled: Bool = false

    override func setUp() {
        super.setUp()
        mockCreateUserUseCase = MockCreateUserUseCase()
        mockCreateUserDataUseCase = MockCreateUserDataUseCase()
        onNavigationCalled = false
        sut = AuthenticationViewModel(
            createUserUseCase: mockCreateUserUseCase,
            createUserDataUseCase: mockCreateUserDataUseCase
        ) {
            self.onNavigationCalled = true
        }
    }

    override func tearDown() {
        sut = nil
        mockCreateUserUseCase = nil
        mockCreateUserDataUseCase = nil
        super.tearDown()
    }

    func testNameValidation() {
        // given
        sut.name = "J"

        // when
        sut.setupValidation()

        // then
        XCTAssertFalse(sut.isNameValid)
        XCTAssertEqual(sut.nameError, "Name must be at least 2 characters.")

        // Test valid case
        sut.name = "John Doe"
        XCTAssertTrue(sut.isNameValid)
        XCTAssertEqual(sut.nameError, "")
    }

    func testLoginValidation() {
        // given
        sut.login = "abc"

        // when
        sut.setupValidation()

        // then
        XCTAssertFalse(sut.isLoginValid)
        XCTAssertEqual(sut.loginError, "Login must be at least 4 alphanumeric characters.")

        // Test valid case
        sut.login = "validLogin123"
        XCTAssertTrue(sut.isLoginValid)
        XCTAssertEqual(sut.loginError, "")
    }

    func testPasswordValidation() {
        // given
        sut.password = "weakpass"

        // when
        sut.setupValidation()

        // then
        XCTAssertFalse(sut.isPasswordValid)
        XCTAssertEqual(
            sut.passwordError,
            """
            Password must be at least 8 characters,
            include uppercase and lowercase letters,
            a number, and a special character.
            """
        )

        // Test valid case
        sut.password = "StrongP@ssw0rd"
        XCTAssertTrue(sut.isPasswordValid)
        XCTAssertEqual(sut.passwordError, "")
    }

    func testConfirmPasswordValidation() {
        // given
        sut.password = "StrongP@ssw0rd"
        sut.confirmPassword = "StrongP@ss"

        // when
        sut.setupValidation()

        // then
        XCTAssertFalse(sut.doPasswordsMatch)
        XCTAssertEqual(sut.confirmPasswordError, "Passwords do not match.")

        // Test valid case
        sut.confirmPassword = "StrongP@ssw0rd"
        XCTAssertTrue(sut.doPasswordsMatch)
        XCTAssertEqual(sut.confirmPasswordError, "")
    }

    func testOverallFormValidity() {
        // given
        sut.name = "John Doe"
        sut.login = "john123"
        sut.password = "StrongP@ssw0rd"
        sut.confirmPassword = "StrongP@ssw0rd"

        // when
        sut.setupValidation()

        // then
        XCTAssertTrue(sut.isFormValid)
    }

    func testCreateAccount_Success() async throws {
        // given
        sut.name = "John Doe"
        sut.login = "john123"
        sut.password = "StrongP@ssw0rd"
        sut.confirmPassword = "StrongP@ssw0rd"

        // when
        try await sut.createAccount()

        // then
        XCTAssertEqual(mockCreateUserUseCase.createdUsers.count, 1)
        XCTAssertEqual(mockCreateUserDataUseCase.createdUsersDataIDs.count, 1)
        XCTAssertTrue(onNavigationCalled)
    }

    func testCreateAccount_FailureInCreateUserUseCase() async throws {
        // given
        sut.name = "John Doe"
        sut.login = "john123"
        sut.password = "StrongP@ssw0rd"
        sut.confirmPassword = "StrongP@ssw0rd"
        mockCreateUserUseCase.shouldThrowError = true

        // when
        do {
            try await sut.createAccount()
            XCTFail("Expected error to be thrown.")
        } catch {
            // then
            XCTAssertEqual(mockCreateUserUseCase.createdUsers.count, 0)
            XCTAssertEqual(mockCreateUserDataUseCase.createdUsersDataIDs.count, 0)
            XCTAssertFalse(onNavigationCalled)
        }
    }

    func testCreateAccount_FailureInCreateUserDataUseCase() async throws {
        // given
        sut.name = "John Doe"
        sut.login = "john123"
        sut.password = "StrongP@ssw0rd"
        sut.confirmPassword = "StrongP@ssw0rd"
        mockCreateUserDataUseCase.shouldThrowError = true

        // when
        do {
            try await sut.createAccount()
            XCTFail("Expected error to be thrown.")
        } catch {
            // then
            XCTAssertEqual(mockCreateUserUseCase.createdUsers.count, 1)
            XCTAssertEqual(mockCreateUserDataUseCase.createdUsersDataIDs.count, 0)
            XCTAssertFalse(onNavigationCalled)
        }
    }
}
