//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import SwiftUI
import ProductCartPresentation
import CoreEntities
import CoreDependencies

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
            self.path.append(screen)
    }

    private func pop() {
            self.path.removeLast()
    }
    
    @ViewBuilder
    func build(screen: ProductCartScreen) -> some View {
        switch screen {
        case .productCart:
            ProductCartView(viewModel: ProductCartViewModel(user: user, getImageUseCase: container.getImageUseCase, getAllProductsUseCase: container.getAllProductsUseCase, addProductToCartUseCase: container.addProductToCartUseCase, removeProductFromCartUseCase: container.removeProductFromCartUseCase, removeAllProductsFromCartUseCase: container.removeAllProductsFromCartUseCase, removeEntireItemUseCase: container.removeEntireItemFromCartUseCase))
        }
    }
}
    
