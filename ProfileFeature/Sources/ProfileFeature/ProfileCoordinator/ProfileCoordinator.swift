//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import SwiftUI
import CoreEntities
import ProfilePresentation
final class ProfileCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProfileDIContainerProtocol
    private let user: User
    private let onLogout: () -> Void
    init(container: ProfileDIContainerProtocol, user: User, onLogout: @escaping () -> Void) {
        self.container = container
        self.user = user
        self.onLogout = onLogout
    }

    private func push(screen: ProfileScreen) {
        DispatchQueue.main.async {
            self.path.append(screen)
        }
    }

    private func pop() {
        DispatchQueue.main.async {
            self.path.removeLast()
        }
    }

    private func showChangePassword(user: User) {
        self.push(screen: .changePassword(user))
    }

    // The logout logic will be handled externally
    private func logout() {
        onLogout()
    }

    @ViewBuilder
    func build(screen: ProfileScreen) -> some View {
        switch screen {
        case .profile:
            ProfileView(viewModel: ProfileViewModel(
                user: self.user,
                updateUserNameUseCase: container.updateUserNameUseCase,
                updateLoginUseCase: container.updateLoginUseCase,
                updateProfilePictureUseCase: container.updateProfilePictureUseCase,
                getProfilePictureUseCase: container.getProfilePictureUseCase,
                signOutUseCase: container.signOutUseCase,
                onNavigation: { [weak self] target in
                    guard let self = self else { return }
                    switch target {
                    case .changePassword(let user):
                        self.showChangePassword(user: user)
                    case .logout:
                        self.logout()
                    }
                }))
        case .changePassword(let user):
            ChangePasswordView(viewModel: ChangePasswordViewModel(
                user: user,
                updatePasswordUseCase: container.updatePasswordUseCase,
                onNavigation: { [weak self] in
                    self?.pop()
                }))
        }
    }
}
