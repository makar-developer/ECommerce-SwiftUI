@testable import CoreEntities
@testable import CoreStyleguide
@testable import CoreTestHelpers
@testable import CoreUseCases
import XCTest
import UIKit

final class ProductDetailsViewModelTests: XCTestCase {

    private var mockAddToCartUseCase: MockAddProductToCartUseCase!
    private var mockAddToHistoryUseCase: MockAddProductToHistoryUseCase!
    private var mockGetImageUseCase: MockGetImageUseCase!
    private var sut: ProductDetailsViewModel!

    override func setUp() {
        super.setUp()
        mockAddToCartUseCase = MockAddProductToCartUseCase()
        mockAddToHistoryUseCase = MockAddProductToHistoryUseCase()
        mockGetImageUseCase = MockGetImageUseCase()
        mockGetImageUseCase.imageToReturn = UIImage()                 // stub image

        let user = User.getOneOfThis()
        let product = Product.getOneOfThis()

        sut = ProductDetailsViewModel(
            user: user,
            product: product,
            addProductToCartUseCase: mockAddToCartUseCase,
            addProductToHistoryUseCase: mockAddToHistoryUseCase,
            getImageUseCase: mockGetImageUseCase,
            onNavigation: {}
        )
    }

    override func tearDown() {
        sut = nil
        mockAddToCartUseCase = nil
        mockAddToHistoryUseCase = nil
        mockGetImageUseCase = nil
        super.tearDown()
    }

    // MARK: - addToCart()

    func testAddToCart_Success_ShouldCallUseCaseWithCorrectParameters() async throws {
        // when
        sut.addToCart()
        try await Task.sleep(nanoseconds: 100_000_000)   // give async Task some time

        // then
        XCTAssertEqual(mockAddToCartUseCase.executeCallCount, 1)
        XCTAssertEqual(mockAddToCartUseCase.passedUser, sut.user)
        XCTAssertEqual(mockAddToCartUseCase.passedProduct, sut.product)
    }

    func testAddToCart_Error_ShouldStillCallUseCaseAndCatchError() async throws {
        // given
        mockAddToCartUseCase.errorToThrow = NSError(domain: "CartError", code: 123)

        // when
        sut.addToCart()
        try await Task.sleep(nanoseconds: 100_000_000)

        // then
        XCTAssertEqual(mockAddToCartUseCase.executeCallCount, 1)
    }

    // MARK: - addProductToHistory()

    func testAddProductToHistory_SuccessfulCall() async throws {
        await sut.addProductToHistory()

        XCTAssertEqual(mockAddToHistoryUseCase.executeCallCount, 1)
        XCTAssertEqual(mockAddToHistoryUseCase.passedUserId, sut.user.id)
        XCTAssertEqual(mockAddToHistoryUseCase.passedProduct, sut.product)
    }

    func testAddProductToHistory_WhenUseCaseThrowsError_ShouldCatchIt() async throws {
        mockAddToHistoryUseCase.errorToThrow = NSError(domain: "HistoryError", code: 456)

        await sut.addProductToHistory()

        XCTAssertEqual(mockAddToHistoryUseCase.executeCallCount, 1)
    }
}
