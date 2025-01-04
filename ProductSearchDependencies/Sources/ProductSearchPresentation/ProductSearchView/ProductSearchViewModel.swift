import Combine
import Foundation
import ProductSearchEntities
import ProductSearchDomain
import CoreEntities
import CoreUseCases
import CoreStyleguide

// MARK: - ProductSearchViewModel
@MainActor
public final class ProductSearchViewModel: ObservableObject {
    
    // MARK: - Subtypes
    public enum NavigationTarget {
        case categoryDetails(CategoryResponse)
        case productDetails(Product)
    }
    /// A container for categories plus their thumbnails
    struct CategoriesData {
        let categories: [CategoryResponse]
        let thumbnails: [String: String]
    }
    
    // MARK: - Published Properties
    let onNavigation: (ProductSearchViewModel.NavigationTarget) -> Void
    
    @Published var searchText: String = ""
    @Published var isSearchFocused: Bool = false

    @Published var categoriesState: ScreenState<CategoriesData> = .loading
    @Published var productsState: ScreenState<[Product]> = .loaded(data: [])  // Start empty
    @Published var recentSearchQueries: [SearchQuery] = []
    @Published var showDeleteAllConfirmation: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // Use Cases
    private let searchProductsUseCase: SearchProductsByKeywordUseCaseProtocol
    private let saveSearchQueryUseCase: SaveSearchQueryToRecentsUseCaseProtocol
    private let removeSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol
    private let removeAllSearchQueriesUseCase: RemoveAllSearchQueriesUseCaseProtocol
    private let getCategoryThumbnailUseCase: GetCategoryThumbnailsUseCaseProtocol
    private let getAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol
    private let getAllExistingCategoriesUseCase: GetAllExistingCategoriesUseCaseProtocol
    let getImageUseCase: GetImageUseCaseProtocol
    
    // MARK: - Initialization
    public init(
        searchProductsUseCase: SearchProductsByKeywordUseCaseProtocol,
        saveSearchQueryUseCase: SaveSearchQueryToRecentsUseCaseProtocol,
        removeSearchQueryUseCase: RemoveSearchQueryUseCaseProtocol,
        removeAllSearchQueriesUseCase: RemoveAllSearchQueriesUseCaseProtocol,
        getCategoryThumbnailUseCase: GetCategoryThumbnailsUseCaseProtocol,
        getAllRecentSearchQueriesUseCase: GetAllRecentSearchQueriesUseCaseProtocol,
        getAllExistingCategoriesUseCase: GetAllExistingCategoriesUseCaseProtocol,
        getImageUseCase: GetImageUseCaseProtocol,
        onNavigation: @escaping (ProductSearchViewModel.NavigationTarget) -> Void
    ) {
        self.searchProductsUseCase = searchProductsUseCase
        self.saveSearchQueryUseCase = saveSearchQueryUseCase
        self.removeSearchQueryUseCase = removeSearchQueryUseCase
        self.removeAllSearchQueriesUseCase = removeAllSearchQueriesUseCase
        self.getCategoryThumbnailUseCase = getCategoryThumbnailUseCase
        self.getAllRecentSearchQueriesUseCase = getAllRecentSearchQueriesUseCase
        self.getAllExistingCategoriesUseCase = getAllExistingCategoriesUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation
        
        setupBindings()
        loadRecentSearchQueries()
        // Trigger initial categories load
        loadCategories()
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        $searchText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performSearch(with: text)
            }
            .store(in: &cancellables)
        
        // Reload recent searches when search field is unfocused and we have empty text
        $isSearchFocused
            .sink { [weak self] focused in
                if !focused && self?.searchText.isEmpty == true {
                    self?.loadRecentSearchQueries()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Load Categories
    public func loadCategories() {
        Task {
                categoriesState = .loading
            do {
                let fetchedCategories = try await getAllExistingCategoriesUseCase.execute()
                let slugs = fetchedCategories.map { $0.slug }
                let thumbs = try await getCategoryThumbnailUseCase.execute(categorySlugs: slugs)
                    categoriesState = .loaded(data: CategoriesData(categories: fetchedCategories, thumbnails: thumbs))
            } catch {
                    categoriesState.toError(error: error)
            }
        }
    }

    // MARK: - Perform Search
    private func performSearch(with keyword: String) {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedKeyword.isEmpty {
            // If search text is blank, just show empty results (no error).
            productsState = .loaded(data: [])
            return
        }
        Task {
            await actuallySearchProducts(with: trimmedKeyword)
        }
    }
    
    private func actuallySearchProducts(with keyword: String) async {
        productsState = .loading
        do {
            let results = try await searchProductsUseCase.execute(keyword: keyword)
            productsState = .loaded(data: results)
        } catch {
            productsState.toError(error: error)
        }
    }

    public func performSearch(from query: SearchQuery) {
        searchText = query.query
        isSearchFocused = false
    }
    
    public func saveCurrentSearch() {
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return }
        
        let query = SearchQuery(query: trimmedKeyword)
        saveSearchQueryUseCase.execute(searchQuery: query)
        loadRecentSearchQueries()
    }

    // MARK: - Load Recent Search Queries
    public func loadRecentSearchQueries() {
        let queries = getAllRecentSearchQueriesUseCase.execute()
        recentSearchQueries = queries.sorted { $0.creationDate > $1.creationDate }
    }
    
    // MARK: - Delete Search Queries
    public func deleteSearchQuery(_ query: SearchQuery) {
        removeSearchQueryUseCase.execute(searchQuery: query)
        loadRecentSearchQueries()
    }

    public func deleteAllSearchQueries() {
        removeAllSearchQueriesUseCase.execute()
        loadRecentSearchQueries()
    }
}
