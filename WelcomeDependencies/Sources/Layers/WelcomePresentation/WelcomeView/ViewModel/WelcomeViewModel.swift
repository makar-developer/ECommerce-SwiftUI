//
//  WelcomeViewModel.swift
//
//
//  Created by Admin on 17/11/2024.
//

import CoreEntities
import CoreUseCases
import SwiftUI
import WelcomeDomain

@MainActor
public final class WelcomeViewModel: ObservableObject {
    public enum NavigationTarget {
        case authentication
        case main(User)
    }

    @Published var users: [User] = []
    @Published var isEditingModeEnabled: Bool = false
    private(set) var userCardBackgroundImages: [String] = ["image1", "image2", "image3", "image4", "image5", "image6"]
    private(set) var assignedImages: [UUID: String] = [:]

    private let getAllUsersUseCase: GetAllUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let signInUseCase: SignInUseCaseProtocol
    private let deleteUserDataUseCase: DeleteUserDataUseCaseProtocol
    private let createUserUseCase: CreateUserUseCaseProtocol // This
    private let createUserDataUseCase: CreateUserDataUseCaseProtocol // And this one are injected here just to populate Keychain and CoreData with some default
    // users for testing purposes.
    private let fetchUserDataUseCase: FetchUserDataUseCaseProtocol

    private var onNavigation: (WelcomeViewModel.NavigationTarget) -> Void

    public init(
        getAllUsersUseCase: GetAllUsersUseCaseProtocol,
        deleteUserUseCase: DeleteUserUseCaseProtocol,
        signInUseCase: SignInUseCaseProtocol,
        deleteUserDataUseCase: DeleteUserDataUseCaseProtocol,
        createUserUseCase: CreateUserUseCaseProtocol,
        createUserDataUseCase: CreateUserDataUseCaseProtocol,
        fetchUserDataUseCase: FetchUserDataUseCaseProtocol,
        onNavigation: @escaping (WelcomeViewModel.NavigationTarget) -> Void
    ) {
        self.getAllUsersUseCase = getAllUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.signInUseCase = signInUseCase
        self.deleteUserDataUseCase = deleteUserDataUseCase
        self.createUserUseCase = createUserUseCase
        self.createUserDataUseCase = createUserDataUseCase
        self.fetchUserDataUseCase = fetchUserDataUseCase
        self.onNavigation = onNavigation
    }

    func loadUsers() async {
        do {
            let isFirstFetch = !UserDefaults.standard.bool(forKey: "hasFetchedUsersBefore")

            if isFirstFetch {
                // Initialize some default users for testing purposes
                let userData = [
                    ("DefaultUser1", "user1", "Password1@"),
                    ("DefaultUser2", "user2", "Password2@"),
                    ("DefaultUser3", "user3", "Password3@"),
                    ("DefaultUser4", "user4", "Password4@"),
                    ("DefaultUser5", "user5", "Password5@"),
                ]

                for (nameString, loginString, passwordString) in userData {
                    guard let name = UserName(rawValue: nameString),
                          let login = Login(rawValue: loginString),
                          let password = Password(rawValue: passwordString)
                    else {
                        print("Invalid user data for \(nameString)")
                        continue
                    }

                    let newUser = User(
                        name: name,
                        login: login,
                        password: password,
                        profilePicture: nil
                    )

                    // Create user in Keychain
                    try await createUserUseCase.execute(user: newUser)

                    // Create UserData in CoreData
                    try await createUserDataUseCase.execute(user: newUser)
                }

                // Update UserDefaults to indicate that the initial fetch has occurred
                UserDefaults.standard.set(true, forKey: "hasFetchedUsersBefore")
            }

            // Ensure Keychain and CoreData consistency:
            // Some User exists in Keychain but there's no UserData for him ?(e.g. app reinstall) Let's create a new empty one.
            let keychainUsers = try await getAllUsersUseCase.execute()
            for user in keychainUsers {
                let userDataId = try await fetchUserDataUseCase.execute(userId: user.id)
                if userDataId == nil {
                    try await createUserDataUseCase.execute(user: user)
                }
            }

            // Then just fetch & display your users
            users = keychainUsers
            assignUniqueImages()
        } catch {
            // Handle error
            print("Error fetching users: \(error.localizedDescription)")
        }
    }

    private func assignUniqueImages() {
        var availableImages = userCardBackgroundImages.shuffled()
        for user in users {
            if availableImages.isEmpty {
                availableImages = userCardBackgroundImages.shuffled()
            }
            if let image = availableImages.popLast() {
                assignedImages[user.id] = image
            }
        }
    }

    func getImage(for user: User) -> String {
        return assignedImages[user.id] ?? "defaultImage"
    }

    func deleteUser(user: User) {
        Task {
            do {
                try await deleteUserUseCase.execute(user: user)
                try await deleteUserDataUseCase.execute(userId: user.id)
                // Handle logout success
                users.removeAll { $0.id == user.id }
                isEditingModeEnabled = false
                assignedImages.removeValue(forKey: user.id)
            } catch {
                // Handle logout error
                print("Error logging out user: \(error.localizedDescription)")
            }
        }
    }

    func signIn(user: User) {
        Task {
            do {
                try await signInUseCase.execute(user: user)
            } catch {
                print("Error signing in user: \(error.localizedDescription)")
            }
        }
    }

    func toggleEditingMode() {
        isEditingModeEnabled.toggle()
    }

    func showAuthentication() {
        onNavigation(.authentication)
    }

    func showMain(user: User) {
        onNavigation(.main(user))
    }
}
