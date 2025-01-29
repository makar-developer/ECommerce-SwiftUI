
import SwiftUI
import ProductDiscoverRepositoryProtocol
import ProductDiscoverDomain
import ProductDiscoverRepository
import CoreDataSources
public protocol ProductDiscoverDIContainerProtocol {
    // MARK: - Use Cases
    var getHotSalesUseCase: GetHotSalesUseCaseProtocol { get }
    var getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol { get }

    // MARK: - Repositories
    var productDiscoverRepository: ProductDiscoverRepositoryProtocol { get }
}

public final class ProductDiscoverDIContainerImpl: ProductDiscoverDIContainerProtocol {
    //MARK: - Data Sources
    public lazy var networkService: NetworkServiceDataSourceProtocol = {
        return NetworkServiceDataSourceImpl(baseURL: URL(string: "https://dummyjson.com/products")!)
    }()
    
    // MARK: - Repositories
    public lazy var productDiscoverRepository: ProductDiscoverRepositoryProtocol = {
        return ProductDiscoverRepositoryImpl(networkService: networkService)
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
////    var deleteUserUseCase: LogoutUserUseCaseProtocol { get }
////    var createUserUseCase: CreateUserUseCaseProtocol { get }
//    // MARK: - Repositories
////    var ProductDiscoverReposiqory: ProductDiscoverRepositoryProtocol { get }
//}
//
//
//public final class ProductDiscoverDIContainerImpl: ProductDiscoverDIContainerProtocol {
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
////    public lazy var deleteUserUseCase: LogoutUserUseCaseProtocol = {
////        return LogoutUserUseCase(ProductDiscoverRepository: ProductDiscoverRepository)
////    }()
////    // AuthenticationView
////    public lazy var createUserUseCase: CreateUserUseCaseProtocol = {
////        return CreateUserUseCase(ProductDiscoverRepository: ProductDiscoverRepository)
////    }()
//    public init() {}
//}
//
