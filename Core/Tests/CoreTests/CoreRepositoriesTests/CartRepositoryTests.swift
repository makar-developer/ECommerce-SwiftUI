import CoreData
@testable import CoreDataSources
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
import XCTest

final class CartRepositoryTests: XCTestCase {

    private var sut: CartRepositoryImpl!
    private var mockCoreDataDataSource: MockCoreDataDataSource!

    override func setUp() {
        super.setUp()
        mockCoreDataDataSource = MockCoreDataDataSource(modelName: "UserData")
        sut = CartRepositoryImpl(coreDataDataSource: mockCoreDataDataSource)
    }

    override func tearDown() {
        sut = nil
        mockCoreDataDataSource = nil
        super.tearDown()
    }

    // MARK: - getCart(for:)

    func test_getCart_whenNoExistingCart_createsNewCart() async throws {
        let user = User.getOneOfThis()
        let cart = try await sut.getCart(for: user)

        XCTAssertEqual(cart.userId, user.id)
        XCTAssertTrue(cart.products.isEmpty)
    }

    func test_getCart_whenCartAlreadyExists_returnsExistingCart() async throws {
        let user = User.getOneOfThis()
        _ = try await createCartEntityInMemory(for: user)

        let cart = try await sut.getCart(for: user)

        XCTAssertEqual(cart.userId, user.id)
        XCTAssertEqual(cart.products.count, 0)
    }

    // MARK: - addItem(_:to:)

    func test_addItem_whenItemDoesNotExist_createsNewItemInCart() async throws {
        let user = User.getOneOfThis()
        _ = try await sut.getCart(for: user)                 // make sure cart exists

        let item = CartItem.getOneOfThis()
        try await sut.addItem(item, to: user)

        let updatedCart = try await sut.getCart(for: user)
        XCTAssertEqual(updatedCart.products.count, 1)
        XCTAssertEqual(updatedCart.products.first?.product.id, item.product.id)
    }

    func test_addItem_whenItemAlreadyInCart_incrementsQuantity() async throws {
        let user = User.getOneOfThis()
        _ = try await sut.getCart(for: user)

        let item = CartItem.getOneOfThis()
        try await sut.addItem(item, to: user)        // first time
        try await sut.addItem(item, to: user)        // second time

        let cart = try await sut.getCart(for: user)
        XCTAssertEqual(cart.products.count, 1)
        XCTAssertEqual(cart.products.first?.quantity, item.quantity * 2)
    }

    // MARK: - updateItem(_:for:)

    func test_updateItem_whenItemExists_updatesQuantity() async throws {
        let user = User.getOneOfThis()
        _ = try await sut.getCart(for: user)

        var item = CartItem.getOneOfThis()
        item.quantity = 2
        try await sut.addItem(item, to: user)

        let updatedItem = CartItem(product: item.product, quantity: 5, id: item.id)
        try await sut.updateItem(updatedItem, for: user)

        let cart = try await sut.getCart(for: user)
        XCTAssertEqual(cart.products.first?.quantity, 5)
    }

    // MARK: - Helpers

    private func createCartEntityInMemory(for user: User) async throws -> CartEntity {
        let cartEntity = Cart(products: [], userId: user.id).toCoreData(context: mockCoreDataDataSource.context)
        cartEntity.userData = try await fetchOrCreateUserData(for: user)
        try await mockCoreDataDataSource.save()
        return cartEntity
    }

    private func fetchOrCreateUserData(for user: User) async throws -> UserDataEntity {
        let request = NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        if let existing = try await mockCoreDataDataSource.fetch(request).first {
            return existing
        } else {
            let entity = user.toCoreData(context: mockCoreDataDataSource.context)
            try await mockCoreDataDataSource.save()
            return entity
        }
    }
}
