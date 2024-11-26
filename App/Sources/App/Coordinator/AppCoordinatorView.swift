//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import SwiftUI
public struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    public init(container: AppDIContainerProtocol) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(feature: .welcome)
                .navigationDestination(for: Feature.self) { feature in
                    coordinator.build(feature: feature)
                }
        }
    }
}
