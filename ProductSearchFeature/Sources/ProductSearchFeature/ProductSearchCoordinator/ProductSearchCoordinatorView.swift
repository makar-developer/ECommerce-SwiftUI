//
//  ProductSearchCoordinatorView.swift
//
//
//  Created by Admin on 11/12/2024.
//

import CoreDependencies
import CoreEntities
import Foundation
import SwiftUI

public struct ProductSearchCoordinatorView: View {
    @StateObject private var coordinator: ProductSearchCoordinator

    public init(
        container: ProductSearchDIContainerProtocol,
        cartContainer: CartDIContainerProtocol,
        imageCacheContainer: ImageDIContainerProtocol,
        productHistoryContainer: ProductHistoryDIContainerProtocol,
        user: User
    ) {
        _coordinator = StateObject(wrappedValue: ProductSearchCoordinator(
            container: container,
            cartContainer: cartContainer,
            imageCacheContainer: imageCacheContainer,
            productHistoryContainer: productHistoryContainer,
            user: user
        ))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .productSearch)
                .navigationDestination(for: ProductSearchScreen.self) { screen in
                    coordinator.build(screen: screen)
                }
        }
    }
}
