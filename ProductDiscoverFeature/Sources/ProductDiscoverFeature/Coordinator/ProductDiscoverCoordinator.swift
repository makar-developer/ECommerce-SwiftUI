//
//  ProductDiscoverCoordinator.swift
//
//
//  Created by Admin on 29/11/2024.
//

import CoreDependencies
import CoreEntities
import CoreStyleguide
import ProductDiscoverPresentation
import SwiftUI

@MainActor
final class ProductDiscoverCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProductDiscoverDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let imageCacheContainer: ImageDIContainerProtocol
    private let productHistoryContainer: ProductHistoryDIContainerProtocol
    private let user: User

    init(container: ProductDiscoverDIContainerProtocol, cartContainer: CartDIContainerProtocol, imageCacheContainer: ImageDIContainerProtocol, productHistoryContainer: ProductHistoryDIContainerProtocol, user: User) {
        self.container = container
        self.cartContainer = cartContainer
        self.imageCacheContainer = imageCacheContainer
        self.productHistoryContainer = productHistoryContainer
        self.user = user
    }

    private func push(screen: ProductDiscoverScreen) {
        path.append(screen)
    }

    private func pop() {
        path.removeLast()
    }

    private func showProductDetails(product: Product, user: User) {
        push(screen: .productDetails(product, user))
    }

    private func showProductDiscover() {
        pop()
    }

    @ViewBuilder
    func build(screen: ProductDiscoverScreen) -> some View {
        switch screen {
        case .productDiscover:
            ProductDiscoverView(viewModel: ProductDiscoverViewModel(getHotSalesUseCase: container.makeGetHotSalesUseCase(), getRecommendedForYouUseCase: container.makeGetRecommendedForYouUseCase(), getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] product in
                guard let self else { return }
                self.showProductDetails(product: product, user: self.user)
            }))
        case let .productDetails(product, user):
            ProductDetailsView(viewModel: ProductDetailsViewModel(user: user, product: product, addProductToCartUseCase: cartContainer.makeAddProductToCartUseCase(), addProductToHistoryUseCase: productHistoryContainer.makeAddProductToHistoryUseCase(), getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] in
                guard let self else { return }
                self.showProductDiscover()
            }))
        }
    }
}
