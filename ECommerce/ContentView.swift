//
//  ContentView.swift
//  ECommerce
//
//  Created by Admin on 16/11/2024.
//

import SwiftUI
import App
struct ContentView: View {
    var container: AppDIContainerProtocol = AppDIContainerImpl()
    var body: some View {
        AppCoordinatorView(container: container)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
