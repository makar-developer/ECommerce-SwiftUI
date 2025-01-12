import XCTest
@testable import WelcomeRepositoryProtocol
@testable import WelcomeData
@testable import CoreDataSources
@testable import CoreEntities
@testable import CoreTestHelpers

final class WelcomeRepositoryImplTests: XCTestCase {

    private var mockKeychain: MockKeychainWrapper!
    private var sut: WelcomeRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockKeychain = MockKeychainWrapper()
        sut = WelcomeRepositoryImpl(keychainWrapper: mockKeychain)
    }

    override func tearDown() {
        sut = nil
        mockKeychain = nil
        super.tearDown()
    }

    func testGetUsers_Empty_ReturnsEmptyList() async throws {
        // given
        // mockKeychain.storedData is nil by default (no users)

        // when
        let users = try await sut.getUsers()

        // then
        XCTAssertTrue(users.isEmpty, "Expected to get an empty list when no data is stored")
        XCTAssertTrue(mockKeychain.didCallLoad, "getUsers should call load() on KeychainWrapper")
    }

    func testGetUsers_WithStoredData_ReturnsDecodedUsers() async throws {
        // given
        let fakeUsers = User.getAnArrayOfThese()
        let encodedUsers = try JSONEncoder().encode(fakeUsers)
        mockKeychain.storedData = encodedUsers

        // when
        let users = try await sut.getUsers()

        // then
        XCTAssertEqual(users, fakeUsers, "Should decode and return the same users array stored in Keychain")
        XCTAssertTrue(mockKeychain.didCallLoad, "Should call load() to retrieve stored data from Keychain")
    }

    func testSaveUsers_ShouldEncodeAndSaveInKeychain() async throws {
        // given
        let fakeUsers = User.getAnArrayOfThese()

        // when
        try await sut.saveUsers(fakeUsers)

        // then
        XCTAssertTrue(mockKeychain.didCallSave, "Should call save() on KeychainWrapper")
        let decodedUsers = try JSONDecoder().decode([User].self, from: mockKeychain.storedData!)
        XCTAssertEqual(decodedUsers, fakeUsers, "Should encode and store the given array in Keychain")
    }

    func testSaveUser_AppendNewUserToExistingList() async throws {
        // given
        // Suppose we have one existing user in the Keychain
        let existingUser = User.getOneOfThis()
        let existingUsers = [existingUser]
        mockKeychain.storedData = try JSONEncoder().encode(existingUsers)

        // Create a new user to add
        let newUser = User.getAnArrayOfThese()[1]

        // when
        try await sut.saveUser(newUser)

        // then
        XCTAssertTrue(mockKeychain.didCallSave, "Should call save() after adding a new user")
        let decoded = try JSONDecoder().decode([User].self, from: mockKeychain.storedData!)
        XCTAssertTrue(decoded.contains(existingUser), "Should keep existing user in the stored list")
        XCTAssertTrue(decoded.contains(newUser), "Should append the new user to the stored list")
    }

    func testDeleteUser_RemovesUserFromKeychain() async throws {
        // given
        // Start with multiple users in Keychain
        let users = User.getAnArrayOfThese()
        mockKeychain.storedData = try JSONEncoder().encode(users)

        // We'll delete the second user
        let userToRemove = users[1]

        // when
        try await sut.delete(user: userToRemove)

        // then
        XCTAssertTrue(mockKeychain.didCallSave, "Should call save() after deleting a user")
        let decoded = try JSONDecoder().decode([User].self, from: mockKeychain.storedData!)
        XCTAssertFalse(decoded.contains(userToRemove), "Should remove the specified user from Keychain data")
    }
}
