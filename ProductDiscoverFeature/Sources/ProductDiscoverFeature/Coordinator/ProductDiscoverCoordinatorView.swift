//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import SwiftUI
import CoreEntities
import CoreDependencies
public struct ProductDiscoverCoordinatorView: View {
    @StateObject private var coordinator: ProductDiscoverCoordinator
    
    public init(container: ProductDiscoverDIContainerProtocol, cartContainer: CartDIContainerProtocol, imageCacheContainer: ImageDIContainerProtocol, productHistoryContainer: ProductHistoryDIContainerProtocol, user: User) {
        _coordinator = StateObject(wrappedValue: ProductDiscoverCoordinator(container: container, cartContainer: cartContainer, imageCacheContainer: imageCacheContainer, productHistoryContainer: productHistoryContainer, user: user))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .productDiscover)
                .navigationDestination(for: ProductDiscoverScreen.self) { screen in
                    coordinator.build(screen: screen)
                }
        }
    }
}
