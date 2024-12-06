//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import Foundation

import SwiftUI
import CoreEntities
import CoreUseCases
public struct ProductCartCoordinatorView: View {
    @StateObject private var coordinator: ProductCartCoordinator
    
    public init(container: CartDIContainerProtocol, user: User) {
        _coordinator = StateObject(wrappedValue: ProductCartCoordinator(container: container, user: user))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .productCart)
                .navigationDestination(for: ProductCartScreen.self) { screen in
                    coordinator.build(screen: screen)
                }
        }
    }
}
