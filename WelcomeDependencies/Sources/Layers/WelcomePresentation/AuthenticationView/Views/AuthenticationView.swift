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
                VStack(alignment: .leading, spacing: 15) {
                    // Header
                    Text(String(localized: "Create Account"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentSecondary)
                        .padding(.top, 10)

                    // Input Fields
                    Group {
                        // Name Field
                        InputField(
                            title: String(localized: "Name"),
                            text: $viewModel.name,
                            error: viewModel.nameError,
                            icon: "person",
                            isSecure: false
                        )

                        // Login Field
                        InputField(
                            title: String(localized: "Login"),
                            text: $viewModel.login,
                            error: viewModel.loginError,
                            icon: "person.circle",
                            isSecure: false
                        )

                        // Password Field
                        InputField(
                            title: String(localized: "Password"),
                            text: $viewModel.password,
                            error: viewModel.passwordError,
                            icon: "lock",
                            isSecure: true
                        )

                        // Confirm Password Field
                        InputField(
                            title: String(localized: "Confirm Password"),
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
                                // Handle successful account creation
                            } catch {
                                // Handle error
                                print("Error creating account: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text(String(localized: "Create Account"))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isFormValid ? Color.accentPrimary : Color.borderColor.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: viewModel.isFormValid ? Color.accentPrimary.opacity(0.7) : Color.borderColor.opacity(0.3),
                                    radius: 4, x: 0, y: 2)
                    }
                    .disabled(!viewModel.isFormValid)
                    .padding(.bottom, 10)
                }
                .padding(.horizontal, 20)
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

import CoreUseCases
import WelcomeDomain
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock use cases
        let mockCreateUserUseCase = MockCreateUserUseCase()
        let mockCreateUserDataUseCase = MockCreateUserDataUseCase()

        // Create a mock view model
        let mockViewModel = AuthenticationViewModel(
            createUserUseCase: mockCreateUserUseCase,
            createUserDataUseCase: mockCreateUserDataUseCase,
            onNavigation: {
                print("Navigation action triggered")
            }
        )

        // Provide default mock data for preview
        mockViewModel.name = "John Doe"
        mockViewModel.login = "johnDoe123"
        mockViewModel.password = "StrongP@ssw0rd"
        mockViewModel.confirmPassword = "StrongP@ssw0rd"

        return NavigationView {
            AuthenticationView(viewModel: mockViewModel)
        }
    }
}
