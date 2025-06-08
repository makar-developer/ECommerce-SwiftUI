import CoreData
@testable import CoreDataSources
@testable import CoreEntities
@testable import CoreRepositories
@testable import CoreTestHelpers
import XCTest

final class ProductHistoryRepositoryTests: XCTestCase {

    private var sut: ProductHistoryRepository!
    private var mockCoreDataDataSource: MockCoreDataDataSource!

    override func setUp() {
        super.setUp()
        mockCoreDataDataSource = MockCoreDataDataSource(modelName: "UserData")
        sut = ProductHistoryRepository(coreDataDataSource: mockCoreDataDataSource)
    }

    override func tearDown() {
        sut = nil
        mockCoreDataDataSource = nil
        super.tearDown()
    }

    // MARK: - getAllHistory(for:)

    func test_getAllHistory_whenRecordsExist_returnsHistoryInDescendingOrder() async throws {
        let user = User.getOneOfThis()
        let histories = ProductHistory.getAnArrayOfThese()
        try await insertProductHistories(histories, for: user)

        let fetched = try await sut.getAllHistory(for: user.id)

        XCTAssertEqual(fetched.count, histories.count)
        XCTAssertTrue(fetched[0].timestamp >= fetched[1].timestamp)
    }

    func test_getAllHistory_whenNoRecordsExist_returnsEmptyArray() async throws {
        let user = User.getOneOfThis()
        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertTrue(fetched.isEmpty)
    }

    // MARK: - addProductToHistory(_:for:)

    func test_addProductToHistory_whenUserExists_insertsNewHistory() async throws {
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)
        let product = Product.getOneOfThis()

        try await sut.addProductToHistory(product, for: user.id)

        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched[0].product.id, product.id)
    }

    func test_addProductToHistory_whenUserDoesNotExist_throwsError() async {
        let product = Product.getOneOfThis()
        let missingUserID = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!

        do {
            try await sut.addProductToHistory(product, for: missingUserID)
            XCTFail("Expected an error")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 404)
        }
    }

    // MARK: - removeProductHistory(_:for:)

    func test_removeProductHistory_whenMatchingRecordsExist_deletesThem() async throws {
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)

        let product1 = Product(id: 99,
                               price: 1,
                               title: "Foo",
                               description: "Bar",
                               category: "Baz",
                               thumbnail: "...",
                               brand: "Brand",
                               images: [],
                               discountPercentage: 0,
                               rating: 0,
                               stock: 0)
        let product2 = Product.getOneOfThis()

        try await sut.addProductToHistory(product1, for: user.id)
        try await sut.addProductToHistory(product2, for: user.id)

        try await sut.removeProductHistory(product1, for: user.id)

        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.product.id, product2.id)
    }

    // MARK: - removeAllHistory(for:)

    func test_removeAllHistory_deletesEverythingForUser() async throws {
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)
        let histories = ProductHistory.getAnArrayOfThese()
        try await insertProductHistories(histories, for: user)

        try await sut.removeAllHistory(for: user.id)

        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertTrue(fetched.isEmpty)
    }

    // MARK: - Helpers

    private func insertUserEntityIfNeeded(_ user: User) async throws {
        let request = NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        if try await mockCoreDataDataSource.fetch(request).isEmpty {
            _ = user.toCoreData(context: mockCoreDataDataSource.context)
            try await mockCoreDataDataSource.save()
        }
    }

    private func insertProductHistories(_ histories: [ProductHistory], for user: User) async throws {
        try await insertUserEntityIfNeeded(user)
        let context = mockCoreDataDataSource.context

        try await context.perform {
            // fetch user entity
            let userRequest = NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
            userRequest.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
            guard let userEntity = try context.fetch(userRequest).first else {
                throw NSError(domain: "Test", code: 404)
            }

            for history in histories {
                let productEntity = try self.fetchOrCreateProductEntity(history.product, in: context)
                let historyEntity = history.toCoreData(context: context)
                historyEntity.userData = userEntity
                historyEntity.product = productEntity
            }
            try context.save()
        }
    }

    private func fetchOrCreateProductEntity(_ product: Product,
                                            in context: NSManagedObjectContext) throws -> ProductEntity {
        let request = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
        request.predicate = NSPredicate(format: "id == %d", product.id)
        if let existing = try context.fetch(request).first {
            return existing
        } else {
            return product.toCoreData(context: context)
        }
    }
}
