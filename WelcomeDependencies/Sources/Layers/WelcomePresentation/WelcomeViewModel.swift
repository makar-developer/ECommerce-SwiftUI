//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import SwiftUI
import WelcomeEntities
import WelcomeDomain

final public class WelcomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isEditingModeEnabled: Bool = false
    @Published var showLogoutAlert: Bool = false

    private let getAllUsersUseCase: GetAllUsersUseCaseProtocol
    private let logoutUserUseCase: LogoutUserUseCaseProtocol
    
    public init(getAllUsersUseCase: GetAllUsersUseCaseProtocol, logoutUserUseCase: LogoutUserUseCaseProtocol) {
        self.getAllUsersUseCase = getAllUsersUseCase
        self.logoutUserUseCase = logoutUserUseCase
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
                // Handle logout success, e.g., remove user from list
                await MainActor.run {
                    users.removeAll { $0.id == user.id }
                    isEditingModeEnabled = false
                    showLogoutAlert = false
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
}
