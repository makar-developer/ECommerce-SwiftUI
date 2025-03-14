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

@MainActor
public final class WelcomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: WelcomeDIContainerProtocol
    private let userDataContainer: UserDataDIContainerProtocol
    private let onNavigation: (User) -> Void
    
    public init(container: WelcomeDIContainerProtocol, userDataContainer: UserDataDIContainerProtocol, onNavigation: @escaping (User) -> Void) {
        self.container = container
        self.userDataContainer = userDataContainer
        self.onNavigation = onNavigation
    }
    
    func showMain(user: User) {
        onNavigation(user)
    }
    @MainActor
    private func push(screen: WelcomeScreen) {
        self.path.append(screen)
    }
    @MainActor
    private func pop() {
        self.path.removeLast()
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
                getAllUsersUseCase: container.makeGetAllUsersUseCase(),
                deleteUserUseCase: container.makeDeleteUserUseCase(),
                signInUseCase: container.makeSignInUseCase(),
                deleteUserDataUseCase: userDataContainer.makeDeleteUserDataUseCase(),
                createUserUseCase: container.makeCreateUserUseCase(),
                createUserDataUseCase: userDataContainer.makeCreateUserDataUseCase(),
                fetchUserDataUseCase: userDataContainer.makeFetchUserDataUseCase(),
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
                createUserUseCase: container.makeCreateUserUseCase(),
                createUserDataUseCase: userDataContainer.makeCreateUserDataUseCase(),
                onNavigation: { [weak self] in
                    self?.showWelcome()
                }
            ))
        }
    }
}

