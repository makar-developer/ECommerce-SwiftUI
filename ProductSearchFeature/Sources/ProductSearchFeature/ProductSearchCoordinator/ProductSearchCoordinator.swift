//
//  ProductSearchCoordinator.swift
//
//
//  Created by Admin on 11/12/2024.
//

import CoreDependencies
import CoreEntities
import CoreStyleguide
import ProductSearchEntities
import ProductSearchPresentation
import SwiftUI

@MainActor
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
        push(screen: .categoryDetails(category, user))
    }

    private func showCategoryDetails() {
        pop()
    }

    private func showProductDetails(product: Product, user: User) {
        push(screen: .productDetails(product, user))
    }

    private func showProductSearch() {
        pop()
    }

    @ViewBuilder
    func build(screen: ProductSearchScreen) -> some View {
        switch screen {
        case let .productDetails(product, user):
            ProductDetailsView(viewModel: ProductDetailsViewModel(
                user: user,
                product: product,
                addProductToCartUseCase: cartContainer.makeAddProductToCartUseCase(),
                addProductToHistoryUseCase: productHistoryContainer.makeAddProductToHistoryUseCase(),
                getImageUseCase: container.getImageUseCase,
                onNavigation: { [weak self] in
                    guard let self else { return }
                    self.showCategoryDetails()
                }
            ))
        case .productSearch:
            ProductSearchView(viewModel: ProductSearchViewModel(
                searchProductsUseCase: container.makeSearchProductsByKeywordUseCase(),
                saveSearchQueryUseCase: container.makeSaveSearchQueryToRecentsUseCase(),
                removeSearchQueryUseCase: container.makeRemoveSearchQueryUseCase(),
                removeAllSearchQueriesUseCase: container.makeRemoveAllSearchQueriesUseCase(),
                getCategoryThumbnailUseCase: container.makeGetCategoryThumbnailUseCase(),
                getAllRecentSearchQueriesUseCase: container.makeGetAllRecentSearchQueriesUseCase(),
                getAllExistingCategoriesUseCase: container.makeGetAllExistingCategoriesUseCase(),
                getImageUseCase: imageCacheContainer.getImageUseCase,
                onNavigation: { [weak self] target in
                    guard let self else { return }

                    switch target {
                    case let .categoryDetails(category):
                        self.showCategoryDetails(category: category, user: self.user)
                    case let .productDetails(product):
                        self.showProductDetails(product: product, user: self.user)
                    }
                }
            ))
        case let .categoryDetails(category, user):
            CategoryDetailsView(viewModel: CategoryDetailsViewModel(
                categoryResponse: category,
                user: user,
                getAllProductsUseCase: container.makeGetAllProductsFromCategoryUseCase(),
                getImageUseCase: imageCacheContainer.getImageUseCase,
                onNavigation: { [weak self] target in
                    guard let self else { return }
                    switch target {
                    case .productSearch:
                        self.showProductSearch()
                    case let .productDetails(product):
                        self.showProductDetails(product: product, user: self.user)
                    }
                }
            ))
        }
    }
}
