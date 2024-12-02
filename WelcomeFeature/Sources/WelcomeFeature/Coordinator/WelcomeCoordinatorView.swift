//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import SwiftUI
import CoreEntities
public struct WelcomeCoordinatorView: View {
    @StateObject private var coordinator: WelcomeCoordinator

    public init(container: WelcomeDIContainerProtocol, onNavigation: @escaping (User) -> Void) {
        _coordinator = StateObject(wrappedValue: WelcomeCoordinator(container: container, onNavigation: onNavigation))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .welcome)
                .navigationDestination(for: WelcomeScreen.self) { screen in
                    coordinator.build(screen: screen)
                }
        }
    }
}
