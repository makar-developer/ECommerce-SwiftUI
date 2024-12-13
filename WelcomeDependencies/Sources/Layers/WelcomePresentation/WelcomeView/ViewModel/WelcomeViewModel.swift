//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import SwiftUI
import CoreEntities
import WelcomeDomain

final public class WelcomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isEditingModeEnabled: Bool = false
    var userCardBackgroundImages: [String] = ["image1", "image2", "image3"]
    var assignedImages: [UUID: String] = [:]
    
    private let getAllUsersUseCase: GetAllUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    
    private var onNavigation: (WelcomeView.NavigationTarget) -> Void
    
    public init(getAllUsersUseCase: GetAllUsersUseCaseProtocol, deleteUserUseCase: DeleteUserUseCaseProtocol, onNavigation: @escaping (WelcomeView.NavigationTarget) -> Void) {
        self.getAllUsersUseCase = getAllUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.onNavigation = onNavigation
    }
    
    @MainActor
    func loadUsers() async {
        do {
            let fetchedUsers = try await getAllUsersUseCase.execute()
            users = fetchedUsers
            assignUniqueImages()
        } catch {
            // Handle error, e.g., show alert
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
                // Handle logout success
                await MainActor.run {
                    users.removeAll { $0.id == user.id }
                    isEditingModeEnabled = false
                    assignedImages.removeValue(forKey: user.id)
                }
            } catch {
                // Handle logout error
                print("Error logging out user: \(error.localizedDescription)")
            }
        }
    }
    
    func loadUserCardBackgroundImages() {
        // Already initialized with images
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
