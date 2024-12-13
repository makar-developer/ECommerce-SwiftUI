import Combine
import CoreEntities
import CoreUseCases
import ProductSearchEntities
import ProductSearchDomain
import Core
import CoreStyleguide
import Foundation
// MARK: - ProductSearchViewModel

public final class ProductSearchViewModel: ObservableObject {
    
    public enum NavigationTarget {
        case categoryDetails(CategoryResponse)
        case productDetails(Product)
    }
    
    let onNavigation: (ProductSearchViewModel.NavigationTarget) -> Void
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var isSearchFocused: Bool = false
    
    @Published var categories: [CategoryResponse] = []
    @Published var categoryThumbnails: [String: String] = [:]
    @Published var products: [Product] = []
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
        loadCategories()
        loadRecentSearchQueries()
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
        
        // Reload recent searches when search field is focused
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
                do {
                    let fetchedCategories = try await getAllExistingCategoriesUseCase.execute()
                    await MainActor.run {
                        categories = fetchedCategories
                        // Immediately load thumbnails after categories are fetched
                        loadCategoryThumbnails()
                    }
                } catch {
                    print("Failed to load categories: \(error)")
                }
            }
        }
    
    public func loadCategoryThumbnails() {
            Task {
                do {
                    // Extract slugs from existing categories
                    let slugs = categories.map { $0.slug }
                    
                    // Fetch thumbnails for all categories
                    let thumbnails = try await getCategoryThumbnailUseCase.execute(categorySlugs: slugs)
                    
                    await MainActor.run {
                        categoryThumbnails = thumbnails
                    }
                } catch {
                    print("Failed to load category thumbnails: \(error)")
                }
            }
        }
    // MARK: - Perform Search
    private func performSearch(with keyword: String) {
        if keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DispatchQueue.main.async {
                self.products = []
            }
            return
        }
        
        Task {
            do {
                let results = try await searchProductsUseCase.execute(keyword: keyword)
                await MainActor.run {
                    products = results
                }
            } catch {
                print("Search error: \(error)")
            }
        }
    }
    
    public func saveCurrentSearch() {
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return }
        
        let query = SearchQuery(query: trimmedKeyword)
        saveSearchQueryUseCase.execute(searchQuery: query)
        loadRecentSearchQueries()
    }
    
    // MARK: - Save Search Query
    private func saveSearch(query: SearchQuery) {
        saveSearchQueryUseCase.execute(searchQuery: query)
        loadRecentSearchQueries()
    }
    
    // MARK: - Load Recent Search Queries
    public func loadRecentSearchQueries() {
        let queries = getAllRecentSearchQueriesUseCase.execute()
        recentSearchQueries = queries.sorted { $0.creationDate > $1.creationDate }
    }
    
    // MARK: - Delete Single Search Query
    public func deleteSearchQuery(_ query: SearchQuery) {
        removeSearchQueryUseCase.execute(searchQuery: query)
        loadRecentSearchQueries()
    }
    
    // MARK: - Delete All Search Queries
    public func deleteAllSearchQueries() {
        removeAllSearchQueriesUseCase.execute()
        loadRecentSearchQueries()
    }
    
    // MARK: - Perform Search from Recent Query
    public func performSearch(from query: SearchQuery) {
        searchText = query.query
        isSearchFocused = false
    }
}
