import CoreUseCases
import CoreRepositories
import CoreDataSources
import ProductSearchDomain
import ProductSearchRepositoryProtocol
import ProductSearchRepository
import Foundation
// MARK: - DI Container Protocol

public protocol ProductSearchDIContainerProtocol {
    // MARK: - Use Cases
    func makeSearchProductsByKeywordUseCase() -> SearchProductsByKeywordUseCaseProtocol
    func makeSaveSearchQueryToRecentsUseCase() -> SaveSearchQueryToRecentsUseCaseProtocol
    func makeRemoveSearchQueryUseCase() -> RemoveSearchQueryUseCaseProtocol
    func makeRemoveAllSearchQueriesUseCase() -> RemoveAllSearchQueriesUseCaseProtocol
    func makeGetCategoryThumbnailUseCase() -> GetCategoryThumbnailsUseCaseProtocol
    func makeGetAllRecentSearchQueriesUseCase() -> GetAllRecentSearchQueriesUseCaseProtocol
    func makeGetAllExistingCategoriesUseCase() -> GetAllExistingCategoriesUseCaseProtocol
    func makeGetAllProductsFromCategoryUseCase() -> GetAllProductsFromCategoryUseCaseProtocol
    var getImageUseCase: GetImageUseCaseProtocol { get }
}

// MARK: - DI Container Implementation

public struct ProductSearchDIContainerImpl: ProductSearchDIContainerProtocol {
    
    public let getImageUseCase: GetImageUseCaseProtocol
    
    // MARK: - DataSources
    private let networkService: NetworkServiceDataSourceProtocol
    private let userDefaultsDataSource: UserDefaultsDataSourceProtocol
    
    // MARK: - Repositories
    private let productSearchRepository: ProductSearchRepositoryProtocol
    private let recentSearchesRepository: RecentSearchesRepositoryProtocol
    
    public init(getImageUseCase: GetImageUseCaseProtocol) {
        self.getImageUseCase = getImageUseCase
        
        // Initialize DataSources
        self.networkService = NetworkServiceDataSourceImpl(baseURL: URL(string: "https://dummyjson.com")!)
        self.userDefaultsDataSource = UserDefaultsDataSource()
        
        // Initialize Repositories
        self.productSearchRepository = ProductSearchRepository(networkService: networkService)
        self.recentSearchesRepository = RecentSearchesRepository(userDefaultsDataSource: userDefaultsDataSource)
    }
    
    // MARK: - Use Cases
    
    /// Use case to search products by keyword
    public func makeSearchProductsByKeywordUseCase() -> SearchProductsByKeywordUseCaseProtocol {
        return SearchProductsByKeywordUseCase(repository: productSearchRepository)
    }
    
    /// Use case to save a search query to recent searches
    public func makeSaveSearchQueryToRecentsUseCase() -> SaveSearchQueryToRecentsUseCaseProtocol {
        return SaveSearchQueryToRecentsUseCase(repository: recentSearchesRepository)
    }
    
    /// Use case to remove a specific search query from recent searches
    public func makeRemoveSearchQueryUseCase() -> RemoveSearchQueryUseCaseProtocol {
        return RemoveSearchQueryUseCase(repository: recentSearchesRepository)
    }
    
    /// Use case to remove all search queries from recent searches
    public func makeRemoveAllSearchQueriesUseCase() -> RemoveAllSearchQueriesUseCaseProtocol {
        return RemoveAllSearchQueriesUseCase(repository: recentSearchesRepository)
    }
    
    /// Use case to get category thumbnail by slug
    public func makeGetCategoryThumbnailUseCase() -> GetCategoryThumbnailsUseCaseProtocol {
        return GetCategoryThumbnailsUseCase(repository: productSearchRepository)
    }
    
    /// Use case to retrieve all recent search queries
    public func makeGetAllRecentSearchQueriesUseCase() -> GetAllRecentSearchQueriesUseCaseProtocol {
        return GetAllRecentSearchQueriesUseCase(repository: recentSearchesRepository)
    }
    
    /// Use case to retrieve all existing categories
    public func makeGetAllExistingCategoriesUseCase() -> GetAllExistingCategoriesUseCaseProtocol {
        return GetAllExistingCategoriesUseCase(repository: productSearchRepository)
    }
    
    public func makeGetAllProductsFromCategoryUseCase() -> GetAllProductsFromCategoryUseCaseProtocol {
        return GetAllProductsFromCategoryUseCase(repository: productSearchRepository)
    }
}
