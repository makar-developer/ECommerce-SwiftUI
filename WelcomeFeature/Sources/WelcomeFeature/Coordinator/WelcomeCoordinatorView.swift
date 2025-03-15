//
//  WelcomeCoordinatorView.swift
//
//
//  Created by Admin on 17/11/2024.
//

import CoreDependencies
import CoreEntities
import SwiftUI

public struct WelcomeCoordinatorView: View {
    @StateObject var coordinator: WelcomeCoordinator
    public init(coordinator: WelcomeCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
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
