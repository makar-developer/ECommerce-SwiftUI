//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
import CoreData
@testable import CoreEntities
@testable import CoreDataSources
@testable import CoreRepositories
@testable import CoreTestHelpers

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
    
    // MARK: - getAllHistory(for:) Tests
    
    func test_getAllHistory_whenRecordsExist_returnsHistoryInDescendingOrder() async throws {
        // given
        let user = User.getOneOfThis()
        // insert 3 ProductHistories with varying timestamps
        let histories = ProductHistory.getAnArrayOfThese()
        try await insertProductHistories(histories, for: user)
        
        // when
        let fetched = try await sut.getAllHistory(for: user.id)
        
        // then
        XCTAssertEqual(fetched.count, histories.count, "Should fetch all inserted product histories.")
        // The repository sorts in descending timestamp
        XCTAssertTrue(fetched[0].timestamp >= fetched[1].timestamp, "Should be sorted in descending order of timestamp.")
    }
    
    func test_getAllHistory_whenNoRecordsExist_returnsEmptyArray() async throws {
        // given
        let user = User.getOneOfThis() // no product history added
        
        // when
        let fetched = try await sut.getAllHistory(for: user.id)
        
        // then
        XCTAssertTrue(fetched.isEmpty, "Should get an empty list if the user has no product history.")
    }
    
    // MARK: - addProductToHistory(_:for:) Tests
    
    func test_addProductToHistory_whenUserExists_insertsNewHistory() async throws {
        // given
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)
        
        let product = Product.getOneOfThis()
        
        // when
        try await sut.addProductToHistory(product, for: user.id)
        
        // then
        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertEqual(fetched.count, 1, "Should have exactly one product history record now.")
        XCTAssertEqual(fetched[0].product.id, product.id, "Inserted history should match the product we added.")
    }
    
    func test_addProductToHistory_whenUserDoesNotExist_throwsError() async {
        // given
        let nonExistentUserID = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!
        let product = Product.getOneOfThis()
        
        // when
        do {
            try await sut.addProductToHistory(product, for: nonExistentUserID)
            XCTFail("Expected an error because the user does not exist.")
        } catch {
            // then
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 404, "Should throw 'User not found' error with code=404.")
        }
    }
    
    // MARK: - removeProductHistory(_:for:) Tests
    
    func test_removeProductHistory_whenMatchingRecordsExist_deletesThem() async throws {
        // given
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)
        
        // Insert a few ProductHistory items
        let product1 = Product(id: 99, price: 1.0, title: "Foo", description: "Bar", category: "Baz",
                               thumbnail: "...", brand: "Brand", images: [], discountPercentage: 0, rating: 0, stock: 0)
        let product2 = Product.getOneOfThis()
        
        try await sut.addProductToHistory(product1, for: user.id)
        try await sut.addProductToHistory(product2, for: user.id)
        
        // when
        try await sut.removeProductHistory(product1, for: user.id)
        
        // then
        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertEqual(fetched.count, 1, "Should have removed the productHistory for product1.")
        XCTAssertEqual(fetched.first?.product.id, product2.id, "Should only keep the product2 record.")
    }
    
    // MARK: - removeAllHistory(for:) Tests
    
    func test_removeAllHistory_deletesEverythingForUser() async throws {
        // given
        let user = User.getOneOfThis()
        try await insertUserEntityIfNeeded(user)
        
        let histories = ProductHistory.getAnArrayOfThese()
        try await insertProductHistories(histories, for: user)
        
        // when
        try await sut.removeAllHistory(for: user.id)
        
        // then
        let fetched = try await sut.getAllHistory(for: user.id)
        XCTAssertTrue(fetched.isEmpty, "Should have removed all product history for this user.")
    }
    
    // MARK: - Private Helpers (for test setup)
    
    /// Insert a UserDataEntity for the given domain user into the mock in-memory store (if not already present).
    private func insertUserEntityIfNeeded(_ user: User) async throws {
        let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        let existing: [UserDataEntity] = try await mockCoreDataDataSource.fetch(entityName: "UserDataEntity", predicate: predicate)
        if existing.isEmpty {
            let newEntity = user.toCoreData(context: mockCoreDataDataSource.context)
            try await mockCoreDataDataSource.save(newEntity)
        }
    }
    
    /// Insert some ProductHistory objects for the user, to simulate existing records.
    private func insertProductHistories(_ histories: [ProductHistory], for user: User) async throws {
        try await insertUserEntityIfNeeded(user)
        
        // We also need to create the actual ProductHistoryEntity + ProductEntity + user relationship
        let context = mockCoreDataDataSource.context
        try context.performAndWait {
            // fetch or create userData
            let userFetch = NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
            userFetch.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
            guard let userDataEntity = try context.fetch(userFetch).first else {
                throw NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "UserDataEntity not found in insertProductHistories"])
            }
            
            for history in histories {
                // create or fetch productEntity
                let productEntity = try fetchOrCreateProductEntity(history.product, in: context)
                
                // create productHistoryEntity
                let historyEntity = history.toCoreData(context: context)
                historyEntity.userData = userDataEntity
                historyEntity.product = productEntity
                context.insert(historyEntity)
            }
            try context.save()
        }
    }
    
    // A lightweight copy of the fetchOrCreate logic from the repository, just for test setup
    private func fetchOrCreateProductEntity(_ product: Product, in context: NSManagedObjectContext) throws -> ProductEntity {
        let request = ProductEntity.fetchRequest() as NSFetchRequest<ProductEntity>
        request.predicate = NSPredicate(format: "id == %d", product.id)
        let results = try context.fetch(request)
        if let existing = results.first {
            return existing
        } else {
            let entity = product.toCoreData(context: context)
            context.insert(entity)
            return entity
        }
    }
}
