//
//  ECommerceApp.swift
//  ECommerce
//
//  Created by Admin on 16/11/2024.
//

import SwiftUI
import App

@main
struct ECommerceApp: App {
    var container = AppDIContainerImpl()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(container: container)
        }
    }
}
