//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import SwiftUI
import CoreEntities
import ProfilePresentation
import CoreDependencies
import CoreStyleguide

@MainActor
final class ProfileCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: ProfileDIContainerProtocol
    private let imageContainer: ImageDIContainerProtocol
    private let productHistoryContainer: ProductHistoryDIContainerProtocol
    private let cartContainer: CartDIContainerProtocol
    private let user: User
    private let onLogout: () -> Void
    init(container: ProfileDIContainerProtocol, imageContainer: ImageDIContainerProtocol, productHistoryContainer: ProductHistoryDIContainerProtocol, cartContainer: CartDIContainerProtocol, user: User, onLogout: @escaping () -> Void) {
        self.container = container
        self.imageContainer = imageContainer
        self.productHistoryContainer = productHistoryContainer
        self.cartContainer = cartContainer
        self.user = user
        self.onLogout = onLogout
    }

    private func push(screen: ProfileScreen) {
            self.path.append(screen)
    }

    private func pop() {
            self.path.removeLast()
    }
    
    private func showChangePassword(user: User) {
        self.push(screen: .changePassword(user))
    }
    
    private func showProductHistory() {
        self.push(screen: .productHistory)
    }
    
    private func showProductDetails(product: Product) {
        self.push(screen: .productDetails(product))
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
                    case .productHistory:
                        self.showProductHistory()
                    }
                }))
        case .changePassword(let user):
            ChangePasswordView(viewModel: ChangePasswordViewModel(
                user: user,
                updatePasswordUseCase: container.updatePasswordUseCase,
                onNavigation: { [weak self] in
                    self?.pop()
                }))
        case .productHistory:
            ProductHistoryView(viewModel: ProductHistoryViewModel(userId: user.id, getProductHistoryUseCase: productHistoryContainer.getProductHistoryUseCase, removeProductFromHistoryUseCase: productHistoryContainer.removeProductFromHistoryUseCase, removeAllHistoryUseCase: productHistoryContainer.removeAllHistoryUseCase, getImageUseCase: imageContainer.getImageUseCase, onNavigation: { target in
                switch target {
                case .productDetails(let product):
                    self.showProductDetails(product: product)
                case .profile:
                    self.pop()
                }
            }))
        case .productDetails(let product):
            ProductDetailsView(viewModel: ProductDetailsViewModel(user: user, product: product, addProductToCartUseCase: cartContainer.addProductToCartUseCase, addProductToHistoryUseCase: productHistoryContainer.addProductToHistoryUseCase, getImageUseCase: imageContainer.getImageUseCase, onNavigation: {
                self.pop()
            }))
        }
    }
}
