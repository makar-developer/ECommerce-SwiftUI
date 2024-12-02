
import SwiftUI
import ProductDiscoverRepositoryProtocol
import ProductDiscoverDomain
import ProductDiscoverRepository
public protocol ProductDiscoverDIContainerProtocol {
    // MARK: - Use Cases
    var getHotSalesUseCase: GetHotSalesUseCaseProtocol { get }
    var getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol { get }

    // MARK: - Repositories
    var productDiscoverRepository: ProductDiscoverRepositoryProtocol { get }
}

public class ProductDiscoverDIContainerImpl: ProductDiscoverDIContainerProtocol {
    // MARK: - Repositories
    public lazy var productDiscoverRepository: ProductDiscoverRepositoryProtocol = {
        return ProductDiscoverRepositoryImpl()
    }()

    // MARK: - Use Cases
    public lazy var getHotSalesUseCase: GetHotSalesUseCaseProtocol = {
        return GetHotSalesUseCase(repository: productDiscoverRepository)
    }()

    public lazy var getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol = {
        return GetRecommendedForYouUseCase(repository: productDiscoverRepository)
    }()

    public init() {}
}

//public protocol ProductDiscoverDIContainerProtocol {
//    // MARK: - Use Cases
////    var getAllUsersUseCase: GetAllUsersUseCaseProtocol { get }
////    var logoutUserUseCase: LogoutUserUseCaseProtocol { get }
////    var createUserUseCase: CreateUserUseCaseProtocol { get }
//    // MARK: - Repositories
////    var ProductDiscoverReposiqory: ProductDiscoverRepositoryProtocol { get }
//}
//
//
//public class ProductDiscoverDIContainerImpl: ProductDiscoverDIContainerProtocol {
//    // MARK: - Repositories
////    public lazy var ProductDiscoverRepository: ProductDiscoverRepositoryProtocol = {
////        return ProductDiscoverRepositoryImpl()
////    }()
//
//    // MARK: - Use Cases
//    // ProductDiscoverView
////    public lazy var getAllUsersUseCase: GetAllUsersUseCaseProtocol = {
////        return GetAllUsersUseCase(ProductDiscoverRepository: ProductDiscoverRepository)
////    }()
////
////    public lazy var logoutUserUseCase: LogoutUserUseCaseProtocol = {
////        return LogoutUserUseCase(ProductDiscoverRepository: ProductDiscoverRepository)
////    }()
////    // AuthenticationView
////    public lazy var createUserUseCase: CreateUserUseCaseProtocol = {
////        return CreateUserUseCase(ProductDiscoverRepository: ProductDiscoverRepository)
////    }()
//    public init() {}
//}
//
