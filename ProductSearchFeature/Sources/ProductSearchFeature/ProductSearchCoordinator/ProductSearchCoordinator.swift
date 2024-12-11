//
//  File.swift
//
//
//  Created by Admin on 11/12/2024.
//


import SwiftUI
import ProductSearchPresentation
import CoreEntities
import CoreStyleguide
import CoreDependencies
final class ProductSearchCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProductSearchDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let imageCacheContainer: ImageDIContainerProtocol
    private let user: User

    init(container: ProductSearchDIContainerProtocol, cartContainer: CartDIContainerProtocol, imageCacheContainer: ImageDIContainerProtocol, user: User) {
        self.container = container
        self.cartContainer = cartContainer
        self.imageCacheContainer = imageCacheContainer
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

//    private func showCategoryDetails(category: Category, user: User) {
//        self.push(screen: .categoryDetails(category, user))
//    }
    
//    private func showProductSearch() {
//        self.push(screen: .productSearch())
//    }

    @ViewBuilder
    func build(screen: ProductSearchScreen) -> some View {
        switch screen {
//        case .productDiscover:
//            ProductSearchView(viewModel: ProductSearchViewModel(getHotSalesUseCase: container.getHotSalesUseCase, getRecommendedForYouUseCase: container.getRecommendedForYouUseCase, getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] product in
//                guard let self else { return }
//                self.showProductDetails(product: product, user: self.user)
//            }))
        case .productDetails(let product, let user):
            ProductDetailsView(viewModel: ProductDetailsViewModel(user: user, product: product, addProductToCartUseCase: cartContainer.addProductToCartUseCase))
        case .productSearch:
            ProductSearchView(viewModel: ProductSearchViewModel(searchProductsUseCase: container.searchProductsByKeywordUseCase, saveSearchQueryUseCase: container.saveSearchQueryToRecentsUseCase, removeSearchQueryUseCase: container.removeSearchQueryUseCase, removeAllSearchQueriesUseCase: container.removeAllSearchQueriesUseCase, getCategoryThumbnailUseCase: container.getCategoryThumbnailUseCase, getAllRecentSearchQueriesUseCase: container.getAllRecentSearchQueriesUseCase, getAllExistingCategoriesUseCase: container.getAllExistingCategoriesUseCase, getImageUseCase: imageCacheContainer.getImageUseCase))
        case .categoryDetails(let category, let user):
            Text(category.name + " " + user.name.rawValue)
            
        }
    }
}

