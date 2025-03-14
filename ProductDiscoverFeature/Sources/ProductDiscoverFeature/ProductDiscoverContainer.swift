
import SwiftUI
import ProductDiscoverRepositoryProtocol
import ProductDiscoverDomain
import ProductDiscoverRepository
import CoreDataSources
public protocol ProductDiscoverDIContainerProtocol {
    // Use Cases
    func makeGetHotSalesUseCase() -> GetHotSalesUseCaseProtocol
    func makeGetRecommendedForYouUseCase() -> GetRecommendedForYouUseCaseProtocol
}

public struct ProductDiscoverDIContainerImpl: ProductDiscoverDIContainerProtocol {
    
    private let networkService: NetworkServiceDataSourceProtocol
    private let productDiscoverRepository: ProductDiscoverRepositoryProtocol
    
    public init() {
        self.networkService = NetworkServiceDataSourceImpl(baseURL: URL(string: "https://dummyjson.com/products")!)
        self.productDiscoverRepository = ProductDiscoverRepositoryImpl(networkService: networkService)
    }
    
    // Use Cases
    public func makeGetHotSalesUseCase() -> GetHotSalesUseCaseProtocol {
        GetHotSalesUseCase(repository: productDiscoverRepository)
    }
    
    public func makeGetRecommendedForYouUseCase() -> GetRecommendedForYouUseCaseProtocol {
        GetRecommendedForYouUseCase(repository: productDiscoverRepository)
    }
}

