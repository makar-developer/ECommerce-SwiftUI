//
//  ProfileCoordinator.swift
//
//
//  Created by Admin on 16/12/2024.
//

import CoreDependencies
import CoreEntities
import CoreStyleguide
import ProfilePresentation
import SwiftUI

@MainActor
final class ProfileCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProfileDIContainerProtocol
    private let imageContainer: ImageDIContainerProtocol
    private let productHistoryContainer: ProductHistoryDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let user: User
    private let onLogout: () -> Void
    init(
        container: ProfileDIContainerProtocol,
        imageContainer: ImageDIContainerProtocol,
        productHistoryContainer: ProductHistoryDIContainerProtocol,
        cartContainer: CartDIContainerProtocol,
        user: User,
        onLogout: @escaping () -> Void
    ) {
        self.container = container
        self.imageContainer = imageContainer
        self.productHistoryContainer = productHistoryContainer
        self.cartContainer = cartContainer
        self.user = user
        self.onLogout = onLogout
    }

    private func push(screen: ProfileScreen) {
        path.append(screen)
    }

    private func pop() {
        path.removeLast()
    }

    private func showChangePassword(user: User) {
        push(screen: .changePassword(user))
    }

    private func showProductHistory() {
        push(screen: .productHistory)
    }

    private func showProductDetails(product: Product) {
        push(screen: .productDetails(product))
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
                user: user,
                updateUserNameUseCase: container.makeUpdateUserNameUseCase(),
                updateLoginUseCase: container.makeUpdateLoginUseCase(),
                updateProfilePictureUseCase: container.makeUpdateProfilePictureUseCase(),
                getProfilePictureUseCase: container.makeGetProfilePictureUseCase(),
                signOutUseCase: container.makeSignOutUseCase(),
                onNavigation: { [weak self] target in
                    guard let self = self else { return }
                    switch target {
                    case let .changePassword(user):
                        self.showChangePassword(user: user)
                    case .logout:
                        self.logout()
                    case .productHistory:
                        self.showProductHistory()
                    }
                }
            ))
        case let .changePassword(user):
            ChangePasswordView(viewModel: ChangePasswordViewModel(
                user: user,
                updatePasswordUseCase: container.makeUpdatePasswordUseCase(),
                onNavigation: { [weak self] in
                    self?.pop()
                }
            ))
        case .productHistory:
            ProductHistoryView(viewModel: ProductHistoryViewModel(
                userId: user.id,
                getProductHistoryUseCase: productHistoryContainer.makeGetProductHistoryUseCase(),
                removeProductFromHistoryUseCase: productHistoryContainer.makeRemoveProductFromHistoryUseCase(),
                removeAllHistoryUseCase: productHistoryContainer.makeRemoveAllHistoryUseCase(),
                getImageUseCase: imageContainer.getImageUseCase,
                onNavigation: { target in
                    switch target {
                    case let .productDetails(product):
                        self.showProductDetails(product: product)
                    case .profile:
                        self.pop()
                    }
                }
            ))
        case let .productDetails(product):
            ProductDetailsView(viewModel: ProductDetailsViewModel(
                user: user,
                product: product,
                addProductToCartUseCase: cartContainer.makeAddProductToCartUseCase(),
                addProductToHistoryUseCase: productHistoryContainer.makeAddProductToHistoryUseCase(),
                getImageUseCase: imageContainer.getImageUseCase,
                onNavigation: {
                    self.pop()
                }
            ))
        }
    }
}
