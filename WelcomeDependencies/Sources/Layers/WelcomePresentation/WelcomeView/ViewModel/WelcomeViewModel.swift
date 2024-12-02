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
    
    private let getAllUsersUseCase: GetAllUsersUseCaseProtocol
    private let logoutUserUseCase: LogoutUserUseCaseProtocol
    
    private var onNavigation: (WelcomeView.NavigationTarget) -> Void
    
    public init(getAllUsersUseCase: GetAllUsersUseCaseProtocol, logoutUserUseCase: LogoutUserUseCaseProtocol, onNavigation: @escaping (WelcomeView.NavigationTarget) -> Void) {
        self.getAllUsersUseCase = getAllUsersUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.onNavigation = onNavigation
    }
    
    @MainActor
    func loadUsers() async {
        do {
            let fetchedUsers = try await getAllUsersUseCase.execute()
            users = fetchedUsers
        } catch {
            // Handle error, e.g., show alert
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func logoutUser(user: User) {
        Task {
            do {
                try await logoutUserUseCase.execute(user: user)
                // Handle logout success
                await MainActor.run {
                    users.removeAll { $0.id == user.id }
                    isEditingModeEnabled = false
                }
            } catch {
                // Handle logout error
                print("Error logging out user: \(error.localizedDescription)")
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
