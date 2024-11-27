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
    @Published var path = NavigationPath()
    private let container: WelcomeDIContainerProtocol
    private let onDismiss: () -> Void

    init(container: WelcomeDIContainerProtocol, onDismiss: @escaping () -> Void) {
        self.container = container
        self.onDismiss = onDismiss
    }

    func dismiss() {
        onDismiss()
    }

    private func push(screen: WelcomeScreen) {
        DispatchQueue.main.async {
            self.path.append(screen)
        }
    }

    private func pop() {
        DispatchQueue.main.async {
            self.path.removeLast()
        }
    }

    private func showAuthentication() {
        push(screen: .createAccount)
    }

    private func showWelcome() {
        pop()
    }

    @ViewBuilder
    func build(screen: WelcomeScreen) -> some View {
        switch screen {
        case .welcome:
            WelcomeView(viewModel: WelcomeViewModel(
                getAllUsersUseCase: container.getAllUsersUseCase,
                logoutUserUseCase: container.logoutUserUseCase,
                onNavigation: { [weak self] in
                    self?.showAuthentication()
                }
            ))
        case .createAccount:
            AuthenticationView(viewModel: AuthenticationViewModel(
                createUserUseCase: container.createUserUseCase,
                onNavigation: { [weak self] in
                    self?.showWelcome()
                }
            ))
        }
    }
}

