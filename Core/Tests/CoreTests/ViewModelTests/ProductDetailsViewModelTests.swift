//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import XCTest
@testable import CoreEntities
@testable import CoreUseCases
@testable import CoreTestHelpers
@testable import CoreStyleguide

final class ProductDetailsViewModelTests: XCTestCase {
    
    private var mockAddToCartUseCase: MockAddProductToCartUseCase!
    private var mockAddToHistoryUseCase: MockAddProductToHistoryUseCase!
    private var sut: ProductDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        mockAddToCartUseCase = MockAddProductToCartUseCase()
        mockAddToHistoryUseCase = MockAddProductToHistoryUseCase()
        
        let user = User.getOneOfThis()
        let product = Product.getOneOfThis()
        
        sut = ProductDetailsViewModel(
            user: user,
            product: product,
            addProductToCartUseCase: mockAddToCartUseCase,
            addProductToHistoryUseCase: mockAddToHistoryUseCase
        ) {

        }
    }
    
    override func tearDown() {
        sut = nil
        mockAddToCartUseCase = nil
        mockAddToHistoryUseCase = nil
        super.tearDown()
    }
    
    func testAddToCart_Success_ShouldCallUseCaseWithCorrectParameters() async throws {
        // given
        let expectedUser = sut.user
        let expectedProduct = sut.product
        
        // when
        sut.addToCart()
        
        // Await a short delay to allow the async Task to complete
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // then
        XCTAssertEqual(mockAddToCartUseCase.executeCallCount, 1, "Expected to call addToCartUseCase exactly once")
        XCTAssertEqual(mockAddToCartUseCase.passedUser, expectedUser, "Should pass the correct User")
        XCTAssertEqual(mockAddToCartUseCase.passedProduct, expectedProduct, "Should pass the correct Product")
    }
    
    func testAddToCart_Error_ShouldStillCallUseCaseAndCatchError() async throws {
        // given
        mockAddToCartUseCase.errorToThrow = NSError(domain: "CartError", code: 123)
        
        // when
        sut.addToCart()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // then
        XCTAssertEqual(mockAddToCartUseCase.executeCallCount, 1, "Should call useCase even if it throws")
    }
    
    func testAddProductToHistory_SuccessfulCall() async throws {
        // given
        let expectedUserId = sut.user.id
        let expectedProduct = sut.product
        
        // when
        await sut.addProductToHistory()
        
        // then
        XCTAssertEqual(mockAddToHistoryUseCase.executeCallCount, 1)
        XCTAssertEqual(mockAddToHistoryUseCase.passedUserId, expectedUserId)
        XCTAssertEqual(mockAddToHistoryUseCase.passedProduct, expectedProduct)
    }
    
    func testAddProductToHistory_WhenUseCaseThrowsError_ShouldCatchIt() async throws {
        // given
        mockAddToHistoryUseCase.errorToThrow = NSError(domain: "HistoryError", code: 456)
        
        // when
        await sut.addProductToHistory()
        
        // then
        XCTAssertEqual(mockAddToHistoryUseCase.executeCallCount, 1, "Should call useCase even if it throws")
    }
}
