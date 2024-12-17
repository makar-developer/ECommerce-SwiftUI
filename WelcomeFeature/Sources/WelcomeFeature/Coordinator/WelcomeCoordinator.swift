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
import CoreEntities
import CoreDependencies
final class WelcomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: WelcomeDIContainerProtocol
    private let userDataContainer: UserDataDIContainerProtocol
    private let onNavigation: (User) -> Void

    init(container: WelcomeDIContainerProtocol, userDataContainer: UserDataDIContainerProtocol, onNavigation: @escaping (User) -> Void) {
        self.container = container
        self.userDataContainer = userDataContainer
        self.onNavigation = onNavigation
    }

    func showMain(user: User) {
        onNavigation(user)
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
                deleteUserUseCase: container.deleteUserUseCase,
                signInUseCase: container.signInUseCase,
                deleteUserDataUseCase: userDataContainer.deleteUserDataUseCase,
                createUserUseCase: container.createUserUseCase,
                createUserDataUseCase: userDataContainer.createUserDataUseCase,
                fetchUserDataUseCase: userDataContainer.fetchUserDataUseCase,
                onNavigation: { [weak self] target in

                    switch target {
                    case .authentication:
                        self?.showAuthentication()
                    case .main(let user):
                        self?.showMain(user: user)
                    }
                }
            ))
        case .createAccount:
            AuthenticationView(viewModel: AuthenticationViewModel(
                createUserUseCase: container.createUserUseCase, createUserDataUseCase: userDataContainer.createUserDataUseCase,
                onNavigation: { [weak self] in
                    self?.showWelcome()
                }
            ))
        }
    }
}

