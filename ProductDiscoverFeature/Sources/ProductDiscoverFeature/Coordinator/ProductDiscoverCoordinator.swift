//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import SwiftUI
import ProductDiscoverPresentation
import CoreEntities
import CoreStyleguide
import CoreUseCases
import CoreRepositories
final class ProductDiscoverCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProductDiscoverDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let imageCacheContainer: ImageDIContainerProtocol
    private let user: User
    
    init(container: ProductDiscoverDIContainerProtocol, cartContainer: CartDIContainerProtocol, imageCacheContainer: ImageDIContainerProtocol, user: User) {
        self.container = container
        self.cartContainer = cartContainer
        self.imageCacheContainer = imageCacheContainer
        self.user = user
    }

    private func push(screen: ProductDiscoverScreen) {
        DispatchQueue.main.async {
            self.path.append(screen)
        }
    }

    private func pop() {
        DispatchQueue.main.async {
            self.path.removeLast()
        }
    }
    
    private func showProductDetails(product: Product, user: User) {
        self.push(screen: .productDetails(product, user))
    }

    @ViewBuilder
    func build(screen: ProductDiscoverScreen) -> some View {
        switch screen {
        case .productDiscover:
            ProductDiscoverView(viewModel: ProductDiscoverViewModel(getHotSalesUseCase: container.getHotSalesUseCase, getRecommendedForYouUseCase: container.getRecommendedForYouUseCase, getImageUseCase: imageCacheContainer.getImageUseCase, onNavigation: { [weak self] product in
                guard let self else { return }
                self.showProductDetails(product: product, user: self.user)
            }))
        case .productDetails(let product, let user):
            ProductDetailsView(viewModel: ProductDetailsViewModel(user: user, product: product, addProductToCartUseCase: cartContainer.addProductToCartUseCase))
        }
    }
}
	
