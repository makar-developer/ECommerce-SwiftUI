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
    var searchProductsByKeywordUseCase: SearchProductsByKeywordUseCaseProtocol { get }
    var saveSearchQueryToRecentsUseCase: SaveSearchQueryToRecentsUseCaseProtocol { get }
    var removeSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol { get }
    var removeAllSearchQueriesUseCase: RemoveAllSearchQueriesUseCaseProtocol { get }
    var getCategoryThumbnailUseCase: GetCategoryThumbnailsUseCaseProtocol { get }
    var getAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol { get }
    var getAllExistingCategoriesUseCase: GetAllExistingCategoriesUseCaseProtocol { get }
    var getAllProductsFromCategoryUseCase: GetAllProductsFromCategoryUseCaseProtocol { get }
    var getImageUseCase: GetImageUseCaseProtocol { get }
    
    // MARK: - Repositories
    var productSearchRepository: ProductSearchRepositoryProtocol { get }
    var recentSearchesRepository: RecentSearchesRepositoryProtocol { get }
    
    // MARK: - DataSources
    var networkService: NetworkServiceDataSourceProtocol { get }
    var userDefaultsDataSource: UserDefaultsDataSourceProtocol { get }
    var imageCacheDataSource: ImageCacheDataSourceProtocol { get }
}

// MARK: - DI Container Implementation

public final class ProductSearchDIContainerImpl: ProductSearchDIContainerProtocol {
    
    public var getImageUseCase: any CoreUseCases.GetImageUseCaseProtocol
    public var imageCacheDataSource: any CoreDataSources.ImageCacheDataSourceProtocol
    
    public init(imageCacheDataSource: ImageCacheDataSourceProtocol, getImageUseCase: GetImageUseCaseProtocol) {
        self.imageCacheDataSource = imageCacheDataSource
        self.getImageUseCase = getImageUseCase
    }
    // MARK: - DataSources
    
    /// Network Service for API calls
    public lazy var networkService: NetworkServiceDataSourceProtocol = {
        return NetworkServiceDataSourceImpl(baseURL: URL(string: "https://dummyjson.com")!)
    }()

    /// UserDefaults DataSource for storing recent search queries
    public lazy var userDefaultsDataSource: UserDefaultsDataSourceProtocol = {
        return UserDefaultsDataSource()
    }()
    
    // MARK: - Repositories
    
    /// Repository handling product and category-related data operations
    public lazy var productSearchRepository: ProductSearchRepositoryProtocol = {
        return ProductSearchRepository(networkService: networkService)
    }()
    
    /// Repository handling recent search queries
    public lazy var recentSearchesRepository: RecentSearchesRepositoryProtocol = {
        return RecentSearchesRepository(userDefaultsDataSource: userDefaultsDataSource)
    }()
    
    // MARK: - Use Cases
    
    /// Use case to search products by keyword
    public lazy var searchProductsByKeywordUseCase: SearchProductsByKeywordUseCaseProtocol = {
        return SearchProductsByKeywordUseCase(repository: productSearchRepository)
    }()
    
    /// Use case to save a search query to recent searches
    public lazy var saveSearchQueryToRecentsUseCase: SaveSearchQueryToRecentsUseCaseProtocol = {
        return SaveSearchQueryToRecentsUseCase(repository: recentSearchesRepository)
    }()
    
    /// Use case to remove a specific search query from recent searches
    public lazy var removeSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol = {
        return RemoveSearchQueryUseCase(repository: recentSearchesRepository)
    }()
    
    /// Use case to remove all search queries from recent searches
    public lazy var removeAllSearchQueriesUseCase: RemoveAllSearchQueriesUseCaseProtocol = {
        return RemoveAllSearchQueriesUseCase(repository: recentSearchesRepository)
    }()
    
    /// Use case to get category thumbnail by slug
    public lazy var getCategoryThumbnailUseCase: GetCategoryThumbnailsUseCaseProtocol = {
        return GetCategoryThumbnailsUseCase(repository: productSearchRepository)
    }()
    
    /// Use case to retrieve all recent search queries
    public lazy var getAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol = {
        return GetAllRecentSearchQueriesUseCase(repository: recentSearchesRepository)
    }()
    
    /// Use case to retrieve all existing categories
    public lazy var getAllExistingCategoriesUseCase: GetAllExistingCategoriesUseCaseProtocol = {
        return GetAllExistingCategoriesUseCase(repository: productSearchRepository)
    }()
    
    public lazy var getAllProductsFromCategoryUseCase: GetAllProductsFromCategoryUseCaseProtocol = {
        return GetAllProductsFromCategoryUseCase(repository: productSearchRepository)
    }()    
}
