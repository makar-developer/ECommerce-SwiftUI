//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import SwiftUI

public struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    public init(coordinator: AppCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        coordinator.buildRootView()
            .fullScreenCover(item: $coordinator.fullScreenCoverFeature) { feature in
                coordinator.build(feature: feature)
            }
    }
}
