// AuthenticationView.swift
import SwiftUI

public struct AuthenticationView: View {
    @StateObject private var viewModel: AuthenticationViewModel

    public init(viewModel: AuthenticationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Name Field
                VStack(alignment: .leading) {
                    TextField("Name", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                    if !viewModel.nameError.isEmpty {
                        Text(viewModel.nameError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                // Login Field
                VStack(alignment: .leading) {
                    TextField("Login", text: $viewModel.login)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    if !viewModel.loginError.isEmpty {
                        Text(viewModel.loginError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                // Password Field
                VStack(alignment: .leading) {
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !viewModel.passwordError.isEmpty {
                        Text(viewModel.passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                // Confirm Password Field
                VStack(alignment: .leading) {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !viewModel.confirmPasswordError.isEmpty {
                        Text(viewModel.confirmPasswordError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                // Validation Requirements
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password Requirements:")
                        .font(.headline)
                    HStack {
                        Image(systemName: viewModel.password.count >= 8 ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(viewModel.password.count >= 8 ? .green : .red)
                        Text("At least 8 characters")
                    }
                    HStack {
                        Image(systemName: viewModel.password.range(of: "[A-Z]", options: .regularExpression) != nil ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(viewModel.password.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .red)
                        Text("At least one uppercase letter")
                    }
                    HStack {
                        Image(systemName: viewModel.password.range(of: "[a-z]", options: .regularExpression) != nil ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(viewModel.password.range(of: "[a-z]", options: .regularExpression) != nil ? .green : .red)
                        Text("At least one lowercase letter")
                    }
                    HStack {
                        Image(systemName: viewModel.password.range(of: "\\d", options: .regularExpression) != nil ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(viewModel.password.range(of: "\\d", options: .regularExpression) != nil ? .green : .red)
                        Text("At least one number")
                    }
                    HStack {
                        Image(systemName: viewModel.password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(viewModel.password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil ? .green : .red)
                        Text("At least one special character")
                    }
                }
                .padding(.top, 10)

                Spacer()

                // Create Account Button
                Button(action: {
                    Task {
                        do {
                            try await viewModel.createAccount()
                            // Handle successful account creation, e.g., dismiss view or show success message
                        } catch {
                            // Handle error, e.g., show alert
                            print("Error creating account: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isFormValid)
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.backToWelcome()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .background(Color(hue: 0.1, saturation: 0.3, brightness: 0.95))
        .onAppear {
            viewModel.setupValidation()
        }
    }
}
