//
//  ECommerceApp.swift
//  ECommerce
//
//  Created by Admin on 16/11/2024.
//

import App
import SwiftUI

@main
struct ECommerceApp: App {
    var container: AppDIContainerProtocol = AppDIContainerImpl()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: AppCoordinator(container: container))
        }
    }
}
