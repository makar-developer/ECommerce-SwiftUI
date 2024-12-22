// AuthenticationView.swift
import SwiftUI
public struct AuthenticationView: View {
    @StateObject private var viewModel: AuthenticationViewModel

    public init(viewModel: AuthenticationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundPrimary, Color.backgroundSecondary]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 15) { // Reduced spacing from 20 to 15
                    // Header
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentSecondary) // Set to accentSecondary
                        .padding(.top, 30) // Reduced top padding

                    // Input Fields
                    Group {
                        // Name Field
                        InputField(
                            title: "Name",
                            text: $viewModel.name,
                            error: viewModel.nameError,
                            icon: "person",
                            isSecure: false
                        )

                        // Login Field
                        InputField(
                            title: "Login",
                            text: $viewModel.login,
                            error: viewModel.loginError,
                            icon: "person.circle",
                            isSecure: false
                        )

                        // Password Field
                        InputField(
                            title: "Password",
                            text: $viewModel.password,
                            error: viewModel.passwordError,
                            icon: "lock",
                            isSecure: true
                        )

                        // Confirm Password Field
                        InputField(
                            title: "Confirm Password",
                            text: $viewModel.confirmPassword,
                            error: viewModel.confirmPasswordError,
                            icon: "lock.rotation",
                            isSecure: true
                        )
                    }

                    // Password Requirements
                    PasswordRequirementsView(password: viewModel.password)

                    Spacer()

                    // Create Account Button
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.createAccount()
                                // Handle successful account creation, e.g., navigate to home
                            } catch {
                                // Handle error, e.g., show alert
                                print("Error creating account: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12) // Reduced vertical padding
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isFormValid ? Color.accentPrimary : Color.borderColor.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: viewModel.isFormValid ? Color.accentPrimary.opacity(0.7) : Color.borderColor.opacity(0.3),
                                    radius: 4, x: 0, y: 2) // Slightly reduced shadow
                    }
                    .disabled(!viewModel.isFormValid)
                    .padding(.bottom, 15) // Reduced bottom padding
                }
                .padding(.horizontal, 25) // Reduced horizontal padding from 30 to 25
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(action: {
                    viewModel.backToWelcome()
                })
            }
        }
        .onAppear {
            viewModel.setupValidation()
        }
    }
}

// MARK: - InputField View

struct InputField: View {
    let title: String
    @Binding var text: String
    let error: String
    let icon: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) { // Reduced spacing from 5 to 4
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.accentSecondary)
                if isSecure {
                    SecureField(title, text: $text)
                        .autocapitalization(.none)
                        .foregroundColor(Color.accentSecondary) // Set text color
                } else {
                    TextField(title, text: $text)
                        .autocapitalization(.words)
                        .foregroundColor(Color.accentSecondary) // Set text color
                }
            }
            .padding(10) // Reduced padding
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(error.isEmpty ? Color.borderColor.opacity(0.5) : Color.errorColor, lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.backgroundSecondary.opacity(0.15))) // Adjusted opacity
            )

            if !error.isEmpty {
                Text(error)
                    .foregroundColor(Color.errorColor)
                    .font(.caption)
                    .padding(.leading, 8) // Reduced leading padding
            }
        }
    }
}

// MARK: - PasswordRequirementsView

struct PasswordRequirementsView: View {
    let password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) { // Reduced spacing from 8 to 6
            Text("Password Requirements:")
                .font(.headline)
                .foregroundColor(Color.accentSecondary) // Set to accentSecondary

            RequirementRow(
                condition: password.count >= 8,
                text: "At least 8 characters"
            )

            RequirementRow(
                condition: password.range(of: "[A-Z]", options: .regularExpression) != nil,
                text: "At least one uppercase letter"
            )

            RequirementRow(
                condition: password.range(of: "[a-z]", options: .regularExpression) != nil,
                text: "At least one lowercase letter"
            )

            RequirementRow(
                condition: password.range(of: "\\d", options: .regularExpression) != nil,
                text: "At least one number"
            )

            RequirementRow(
                condition: password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil,
                text: "At least one special character"
            )
        }
        .padding(10) // Reduced padding
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.backgroundSecondary.opacity(0.25)) // Adjusted opacity for better visibility
        )
    }
}

// MARK: - RequirementRow View

struct RequirementRow: View {
    let condition: Bool
    let text: String

    var body: some View {
        HStack {
            Image(systemName: condition ? "checkmark.circle" : "xmark.circle")
                .foregroundColor(condition ? Color.successColor : Color.errorColor)
            Text(text)
                .foregroundColor(Color.accentSecondary) // Set to accentSecondary
            Spacer()
        }
        .font(.caption)
    }
}

// MARK: - BackButton View

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) { // Reduced spacing from default
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.accentSecondary) // Set to accentSecondary
                Text("Back")
                    .foregroundColor(Color.accentSecondary) // Set to accentSecondary
            }
        }
    }
}
