//
//  File.swift
//
//
//  Created by Admin on 11/12/2024.
//


import SwiftUI
import ProductSearchPresentation
import ProductSearchEntities
import CoreEntities
import CoreStyleguide
import CoreDependencies
final class ProductSearchCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProductSearchDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let imageCacheContainer: ImageDIContainerProtocol
    private let productHistoryContainer: ProductHistoryDIContainerProtocol
    private let user: User

    init(container: ProductSearchDIContainerProtocol, cartContainer: CartDIContainerProtocol, imageCacheContainer: ImageDIContainerProtocol, productHistoryContainer: ProductHistoryDIContainerProtocol, user: User) {
        self.container = container
        self.cartContainer = cartContainer
        self.imageCacheContainer = imageCacheContainer
        self.productHistoryContainer = productHistoryContainer
        self.user = user
    }

    private func push(screen: ProductSearchScreen) {
        DispatchQueue.main.async {
            self.path.append(screen)
        }
    }

    private func pop() {
        DispatchQueue.main.async {
            self.path.removeLast()
        }
    }

    private func showCategoryDetails(category: CategoryResponse, user: User) {
        self.push(screen: .categoryDetails(category, user))
    }
    
    private func showCategoryDetails() {
        self.pop()
    }
    
    private func showProductDetails(product: Product, user: User) {
        self.push(screen: .productDetails(product, user))
    }
    
    private func showProductSearch() {
        self.pop()
    }

    @ViewBuilder
    func build(screen: ProductSearchScreen) -> some View {
        switch screen {
        case .productDetails(let product, let user):
            ProductDetailsView(viewModel: ProductDetailsViewModel(user: user, product: product, addProductToCartUseCase: cartContainer.addProductToCartUseCase, addProductToHistoryUseCase: productHistoryContainer.addProductToHistoryUseCase, onNavigation: { [weak self] in
                guard let self else { return }
                self.showCategoryDetails()
            }))
        case .productSearch:
            ProductSearchView(viewModel: ProductSearchViewModel(searchProductsUseCase: container.searchProductsByKeywordUseCase, saveSearchQueryUseCase: container.saveSearchQueryToRecentsUseCase, removeSearchQueryUseCase: container.removeSearchQueryUseCase, removeAllSearchQueriesUseCase: container.removeAllSearchQueriesUseCase, getCategoryThumbnailUseCase: container.getCategoryThumbnailUseCase, getAllRecentSearchQueriesUseCase: container.getAllRecentSearchQueriesUseCase, getAllExistingCategoriesUseCase: container.getAllExistingCategoriesUseCase, getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] target in
                guard let self else { return }
                
                switch target {
                    
                case .categoryDetails(let category):
                    self.showCategoryDetails(category: category, user: self.user)
                case .productDetails(let product):
                    self.showProductDetails(product: product, user: self.user)
                }
                
            }))
        case .categoryDetails(let category, let user):
            CategoryDetailsView(viewModel: CategoryDetailsViewModel(categoryResponse: category, user: user, getAllProductsUseCase: container.getAllProductsFromCategoryUseCase, getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] target in
                guard let self else { return }
                switch target {
                case .productSearch:
                    self.showProductSearch()
                case .productDetails(let product):
                    self.showProductDetails(product: product, user: self.user)
                }
            }))
        }
    }
}

