//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import SwiftUI
import WelcomePresentation
import WelcomeDomain
import WelcomeData
final class WelcomeCoordinator: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            print("Path changed: \(path)")
        }
    }
    private let container: WelcomeDIContainerProtocol
    
    init(container: WelcomeDIContainerProtocol) {
        self.container = container
    }
    
    private func push(screen: WelcomeScreen) {
        path.append(screen)
    }
    
    private func pop() {
        print("pop in WC")
        path.removeLast()
    }
    
    private func showAuthentication() {
        print("showAuth")
        push(screen: .createAccount)
    }
    
    private func showWelcome() {
        pop()
    }
    
    @ViewBuilder
    func build(screen: WelcomeScreen) -> some View {
        switch screen {
        case .welcome:
            WelcomeView(viewModel: WelcomeViewModel(getAllUsersUseCase: container.getAllUsersUseCase, logoutUserUseCase: container.logoutUserUseCase, onNavigation: { [unowned self] in
                showAuthentication()
            }))
        case .createAccount:
            CreateAccountView(viewModel: CreateAccountViewModel(createUserUseCase: container.createUserUseCase, onNavigation: { [unowned self] in
                showWelcome()
            }))
        }
    }
}

