//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import SwiftUI
import ProductDiscoverPresentation
import CoreEntities
final class ProductDiscoverCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProductDiscoverDIContainerProtocol

    init(container: ProductDiscoverDIContainerProtocol) {
        self.container = container
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
    
    private func showProductDetails(product: Product) {
        
    }

    @ViewBuilder
    func build(screen: ProductDiscoverScreen) -> some View {
        switch screen {
        case .productDiscover:
            ProductDiscoverView(viewModel: ProductDiscoverViewModel(getHotSalesUseCase: container.getHotSalesUseCase, getRecommendedForYouUseCase: container.getRecommendedForYouUseCase), onNavigation: { [weak self] product in
                print(product.title)
            })
        }
    }
}
	
