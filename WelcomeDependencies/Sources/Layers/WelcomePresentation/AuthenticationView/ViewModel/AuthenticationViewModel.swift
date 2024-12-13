// AuthenticationViewModel.swift
import SwiftUI
import Combine
import CoreEntities
import WelcomeDomain

final public class AuthenticationViewModel: ObservableObject {
    // Input Fields
    @Published var name: String = ""
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // Validation States
    @Published var isNameValid: Bool = false
    @Published var isLoginValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var doPasswordsMatch: Bool = false

    // Error Messages
    @Published var nameError: String = ""
    @Published var loginError: String = ""
    @Published var passwordError: String = ""
    @Published var confirmPasswordError: String = ""

    // Overall Form Validity
    @Published var isFormValid: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let createUserUseCase: CreateUserUseCaseProtocol

    private let onNavigation: () -> Void
    
    public init(createUserUseCase: CreateUserUseCaseProtocol, onNavigation: @escaping () -> Void) {
        self.createUserUseCase = createUserUseCase
        self.onNavigation = onNavigation
    }

    func setupValidation() {
        // Name Validation
        $name
            .map { UserName($0) != nil }
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellables)

        $name
            .map { input -> String in
                if input.trimmingCharacters(in: .whitespaces).isEmpty {
                    return "Name cannot be empty."
                } else if input.count < 2 {
                    return "Name must be at least 2 characters."
                } else if input.count > 50 {
                    return "Name cannot exceed 50 characters."
                }
                return ""
            }
            .assign(to: \.nameError, on: self)
            .store(in: &cancellables)

        // Login Validation
        $login
            .map { Login($0) != nil }
            .assign(to: \.isLoginValid, on: self)
            .store(in: &cancellables)

        $login
            .map { input -> String in
                let regex = "^[a-zA-Z0-9]{4,}$"
                if input.isEmpty {
                    return "Login cannot be empty."
                } else if input.range(of: regex, options: .regularExpression) == nil {
                    return "Login must be at least 4 alphanumeric characters."
                }
                return ""
            }
            .assign(to: \.loginError, on: self)
            .store(in: &cancellables)

        // Password Validation
        $password
            .map { Password($0) != nil }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        $password
            .map { input -> String in
                let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}|:<>?~-]).{8,}$"
                if input.isEmpty {
                    return "Password cannot be empty."
                } else if input.range(of: regex, options: .regularExpression) == nil {
                    return """
                           Password must be at least 8 characters,
                           include uppercase and lowercase letters,
                           a number, and a special character.
                           """
                }
                return ""
            }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)

        // Confirm Password Validation
        Publishers.CombineLatest($password, $confirmPassword)
            .map { ($0 == $1) && !$1.isEmpty }
            .assign(to: \.doPasswordsMatch, on: self)
            .store(in: &cancellables)

        $confirmPassword
            .map { confirmPassword -> String in
                if confirmPassword.isEmpty {
                    return "Please confirm your password."
                } else if confirmPassword != self.password {
                    return "Passwords do not match."
                }
                return ""
            }
            .assign(to: \.confirmPasswordError, on: self)
            .store(in: &cancellables)

        // Overall Form Validation
        Publishers.CombineLatest4($isNameValid, $isLoginValid, $isPasswordValid, $doPasswordsMatch)
            .map { $0 && $1 && $2 && $3 }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    func createAccount() async throws {
        guard let userName = UserName(name),
              let userLogin = Login(login),
              let userPassword = Password(password) else {
            // Handle invalid data
            return
        }

        let newUser = User(
            name: userName,
            login: userLogin,
            password: userPassword
        )

        try await createUserUseCase.execute(user: newUser)
        onNavigation()
    }
}
