//
//  ProductCartCoordinator.swift
//
//
//  Created by Admin on 05/12/2024.
//

import CoreDependencies
import CoreEntities
import ProductCartPresentation
import SwiftUI

@MainActor
final class ProductCartCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: CartDIContainerProtocol
    private let user: User

    init(container: CartDIContainerProtocol, user: User) {
        self.container = container
        self.user = user
    }

    private func push(screen: ProductCartScreen) {
        path.append(screen)
    }

    private func pop() {
        path.removeLast()
    }

    @ViewBuilder
    func build(screen: ProductCartScreen) -> some View {
        switch screen {
        case .productCart:
            ProductCartView(viewModel: ProductCartViewModel(
                user: user,
                getImageUseCase: container.getImageUseCase,
                getAllProductsUseCase: container.makeGetAllProductsUseCase(),
                addProductToCartUseCase: container.makeAddProductToCartUseCase(),
                removeProductFromCartUseCase: container.makeRemoveProductFromCartUseCase(),
                removeAllProductsFromCartUseCase: container.makeRemoveAllProductsFromCartUseCase(),
                removeEntireItemUseCase: container.makeRemoveEntireItemFromCartUseCase()
            ))
        }
    }
}
