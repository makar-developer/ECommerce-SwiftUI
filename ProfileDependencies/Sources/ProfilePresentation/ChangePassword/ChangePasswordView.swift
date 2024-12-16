//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//


import SwiftUI

public struct ChangePasswordView: View {
    @StateObject private var viewModel: ChangePasswordViewModel

    public init(viewModel: ChangePasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            SecureField("Current Password", text: $viewModel.currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.currentPassword) { _ in
                    // Validation handled in ViewModel
                }

            if !viewModel.isCurrentPasswordValid && !viewModel.currentPassword.isEmpty {
                Text("Incorrect current password")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            SecureField("New Password", text: $viewModel.newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.newPassword) { _ in
                    // Validation handled in ViewModel
                }

            if !viewModel.isNewPasswordValid && !viewModel.newPassword.isEmpty {
                Text("Password must be at least 8 characters, include uppercase, lowercase, number, and special character")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            SecureField("Confirm New Password", text: $viewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.confirmPassword) { _ in
                    // Validation handled in ViewModel
                }

            if !viewModel.doPasswordsMatch && !viewModel.confirmPassword.isEmpty {
                Text("Passwords do not match")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Change Password") {
                viewModel.changePassword()
            }
            .disabled(!viewModel.canChangePassword || viewModel.isLoading)
            .padding()

            Spacer()
        }
        .padding()
    }
}
