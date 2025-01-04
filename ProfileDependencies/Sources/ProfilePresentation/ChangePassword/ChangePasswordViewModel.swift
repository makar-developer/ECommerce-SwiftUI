//
//  File 2.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import SwiftUI
import Combine
import ProfileDomain
import CoreEntities

@MainActor
public final class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // Validation States
    @Published private(set) var isCurrentPasswordValid: Bool = false
    @Published private(set) var isNewPasswordValid: Bool = false
    @Published private(set) var doPasswordsMatch: Bool = false
    @Published var canChangePassword: Bool = false

    private let user: User
    private let updatePasswordUseCase: UpdatePasswordUseCaseProtocol
    private let onNavigation: () -> Void

    private var cancellables = Set<AnyCancellable>()

    public init(
        user: User,
        updatePasswordUseCase: UpdatePasswordUseCaseProtocol,
        onNavigation: @escaping () -> Void
    ) {
        self.user = user
        self.updatePasswordUseCase = updatePasswordUseCase
        self.onNavigation = onNavigation
        self.setupValidation()
    }

    private func setupValidation() {
        $currentPassword
            .sink { [weak self] input in
                guard let self = self else { return }
                self.isCurrentPasswordValid = self.verifyCurrentPassword(input)
                self.updateCanChangePassword()
            }
            .store(in: &cancellables)

        $newPassword
            .sink { [weak self] input in
                guard let self = self else { return }
                self.isNewPasswordValid = Password(input) != nil
                self.doPasswordsMatch = self.newPassword == self.confirmPassword
                self.updateCanChangePassword()
            }
            .store(in: &cancellables)

        $confirmPassword
            .sink { [weak self] input in
                guard let self = self else { return }
                self.doPasswordsMatch = self.newPassword == self.confirmPassword
                self.updateCanChangePassword()
            }
            .store(in: &cancellables)
    }
    
    private func updateCanChangePassword() {
        canChangePassword = isCurrentPasswordValid && isNewPasswordValid && doPasswordsMatch
    }
    
    func changePassword() {
        guard canChangePassword else { return }
        
        isLoading = true
        Task {
            do {
                try await updatePasswordUseCase.execute(newPassword: newPassword, for: user.id)
                self.isLoading = false
                self.onNavigation()
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func verifyCurrentPassword(_ input: String) -> Bool {
        // Comparing the input with the user's current password
        return input == user.password.rawValue
    }
}
