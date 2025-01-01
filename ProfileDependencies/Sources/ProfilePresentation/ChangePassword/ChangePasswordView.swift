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
        ScrollView {
            VStack(spacing: 20) {
                SecureField(String(localized: "Current Password"), text: $viewModel.currentPassword)
                    .textFieldStyle(CustomSecureFieldStyle())
                    .foregroundColor(.textBackground)

                if !viewModel.isCurrentPasswordValid && !viewModel.currentPassword.isEmpty {
                    Text(String(localized: "Incorrect current password"))
                        .foregroundColor(.errorColor)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                SecureField(String(localized: "New Password"), text: $viewModel.newPassword)
                    .textFieldStyle(CustomSecureFieldStyle())
                    .foregroundColor(.textBackground)

                if !viewModel.isNewPasswordValid && !viewModel.newPassword.isEmpty {
                    Text(String(localized: "Password must be at least 8 characters, include uppercase, lowercase, number, and special character"))
                        .foregroundColor(.errorColor)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                SecureField(String(localized: "Confirm New Password"), text: $viewModel.confirmPassword)
                    .textFieldStyle(CustomSecureFieldStyle())
                    .foregroundColor(.textBackground)

                if !viewModel.doPasswordsMatch && !viewModel.confirmPassword.isEmpty {
                    Text(String(localized: "Passwords do not match"))
                        .foregroundColor(.errorColor)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.errorColor)
                        .padding()
                        .background(Color.backgroundSecondary)
                        .cornerRadius(8)
                }

                Button(action: viewModel.changePassword) {
                    Text(String(localized: "Change Password"))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canChangePassword ? Color.accentPrimary : Color.accentSecondary.opacity(0.6))
                        .foregroundColor(.textBackground)
                        .cornerRadius(30)
                }
                .disabled(!viewModel.canChangePassword || viewModel.isLoading)
                .padding([.horizontal, .top])

                Spacer()
            }
            .padding()
        }
        .background(Color.backgroundPrimary)
    }
}

struct CustomSecureFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color.backgroundPrimary)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
    }
}
