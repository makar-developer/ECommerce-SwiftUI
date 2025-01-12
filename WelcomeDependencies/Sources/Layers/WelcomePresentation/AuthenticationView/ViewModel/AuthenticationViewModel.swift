// AuthenticationViewModel.swift
import SwiftUI
import Combine
import CoreEntities
import WelcomeDomain
import CoreUseCases

@MainActor
public final class AuthenticationViewModel: ObservableObject {
    // Input Fields
    @Published var name: String = "John Doe"
    @Published var login: String = "johnDoe123"
    @Published var password: String = "StrongP@ssw0rd"
    @Published var confirmPassword: String = "StrongP@ssw0rd"

    // Validation States
    @Published private(set) var isNameValid: Bool = false
    @Published private(set) var isLoginValid: Bool = false
    @Published private(set) var isPasswordValid: Bool = false
    @Published private(set) var doPasswordsMatch: Bool = false

    // Error Messages
    @Published private(set) var nameError: String = ""
    @Published private(set) var loginError: String = ""
    @Published private(set) var passwordError: String = ""
    @Published private(set) var confirmPasswordError: String = ""

    // Overall Form Validity
    @Published private(set) var isFormValid: Bool = false

    private(set) var cancellables = Set<AnyCancellable>()
    private let createUserUseCase: CreateUserUseCaseProtocol
    private let createUserDataUseCase: CreateUserDataUseCaseProtocol
    private let onNavigation: () -> Void

    public init(createUserUseCase: CreateUserUseCaseProtocol, createUserDataUseCase: CreateUserDataUseCaseProtocol, onNavigation: @escaping () -> Void) {
        self.createUserUseCase = createUserUseCase
        self.createUserDataUseCase = createUserDataUseCase
        self.onNavigation = onNavigation
        setupValidation()
    }

    func setupValidation() {
        // Name Validation
        $name
            .map { UserName(rawValue: $0) != nil }
            .sink { [weak self] isValid in
                self?.isNameValid = isValid
            }
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
            .sink { [weak self] error in
                self?.nameError = error
            }
            .store(in: &cancellables)

        // Login Validation
        $login
            .map { Login(rawValue: $0) != nil }
            .sink { [weak self] isValid in
                self?.isLoginValid = isValid
            }
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
            .sink { [weak self] error in
                self?.loginError = error
            }
            .store(in: &cancellables)

        // Password Validation
        $password
            .map { Password(rawValue: $0) != nil }
            .sink { [weak self] isValid in
                self?.isPasswordValid = isValid
            }
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
            .sink { [weak self] error in
                self?.passwordError = error
            }
            .store(in: &cancellables)

        // Confirm Password Validation
        Publishers.CombineLatest($password, $confirmPassword)
            .map { ($0 == $1) && !$1.isEmpty }
            .sink { [weak self] match in
                self?.doPasswordsMatch = match
            }
            .store(in: &cancellables)

        $confirmPassword
            .map { [weak self] confirmPassword -> String in
                guard let self = self else { return "" }
                if confirmPassword.isEmpty {
                    return "Please confirm your password."
                } else if confirmPassword != self.password {
                    return "Passwords do not match."
                }
                return ""
            }
            .sink { [weak self] error in
                self?.confirmPasswordError = error
            }
            .store(in: &cancellables)

        // Overall Form Validation
        Publishers.CombineLatest4($isNameValid, $isLoginValid, $isPasswordValid, $doPasswordsMatch)
            .map { $0 && $1 && $2 && $3 }
            .sink { [weak self] isValid in
                self?.isFormValid = isValid
            }
            .store(in: &cancellables)
    }

    func createAccount() async throws {
        guard let userName = UserName(rawValue: name),
              let userLogin = Login(rawValue: login),
              let userPassword = Password(rawValue: password) else {
            // Handle invalid data
            return
        }

        let newUser = User(
            name: userName,
            login: userLogin,
            password: userPassword,
            profilePicture: nil
        )

        try await createUserUseCase.execute(user: newUser)
        try await createUserDataUseCase.execute(user: newUser)
        onNavigation()
    }

    func backToWelcome() {
        onNavigation()
    }
}
