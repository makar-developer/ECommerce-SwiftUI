//
//  File 2.swift
//  
//
//  Created by Admin on 16/12/2024.
//


import SwiftUI
import Combine
import ProfileDomain
import CoreEntities
import CoreUseCases

@MainActor
public final class ProfileViewModel: ObservableObject {
    public enum NavigationTarget {
        case changePassword(User)
        case logout
        case productHistory
    }
    
    @Published private(set) var user: User
    @Published var userName: String
    @Published var login: String
    @Published private(set) var profilePictureData: Data?
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    // Validation States
    @Published private(set) var isUserNameValid: Bool = false
    @Published private(set) var isLoginValid: Bool = false
    @Published private(set) var canSaveChanges: Bool = false
    
    private let updateUserNameUseCase: UpdateUserNameUseCaseProtocol
    private let updateLoginUseCase: UpdateLoginUseCaseProtocol
    private let updateProfilePictureUseCase: UpdateProfilePictureUseCaseProtocol
    private let getProfilePictureUseCase: GetProfilePictureUseCaseProtocol
    private var signOutUseCase: SignOutUseCaseProtocol
    private let onNavigation: (NavigationTarget) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        user: User,
        updateUserNameUseCase: UpdateUserNameUseCaseProtocol,
        updateLoginUseCase: UpdateLoginUseCaseProtocol,
        updateProfilePictureUseCase: UpdateProfilePictureUseCaseProtocol,
        getProfilePictureUseCase: GetProfilePictureUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol,
        onNavigation: @escaping (NavigationTarget) -> Void
    ) {
        self.user = user
        self.userName = user.name.rawValue
        self.login = user.login.rawValue
        self.updateUserNameUseCase = updateUserNameUseCase
        self.updateLoginUseCase = updateLoginUseCase
        self.updateProfilePictureUseCase = updateProfilePictureUseCase
        self.getProfilePictureUseCase = getProfilePictureUseCase
        self.signOutUseCase = signOutUseCase
        self.onNavigation = onNavigation
        self.setupValidation()
    }
    
    func setupValidation() {
        $userName
            .sink { [weak self] newName in
                guard let self = self else { return }
                self.isUserNameValid = UserName(newName) != nil
                self.updateCanSaveChanges()
            }
            .store(in: &cancellables)
        
        $login
            .sink { [weak self] newLogin in
                guard let self = self else { return }
                self.isLoginValid = Login(newLogin) != nil
                self.updateCanSaveChanges()
            }
            .store(in: &cancellables)
    }
    
    private func updateCanSaveChanges() {
        canSaveChanges = isUserNameValid && isLoginValid
    }
    
    func loadProfilePicture() {
        Task {
            do {
                let data = try await getProfilePictureUseCase.execute(for: user.id)
                self.profilePictureData = data
            } catch {
                // Handle error if necessary
            }
        }
    }
    
    func updateProfilePicture(with data: Data?) {
        isLoading = true
        Task {
            do {
                try await updateProfilePictureUseCase.execute(data: data, for: user.id)
                self.profilePictureData = data
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func saveChanges() {
        guard canSaveChanges else { return }
        isLoading = true
        Task {
            do {
                try await updateUserNameUseCase.execute(newName: userName, for: user.id)
                try await updateLoginUseCase.execute(newLogin: login, for: user.id)
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func changePassword() {
        onNavigation(.changePassword(user))
    }
    
    func logout() {
        Task {
            try await signOutUseCase.execute()
        }
        onNavigation(.logout)
    }
    
    func showProductHistory() {
        onNavigation(.productHistory)
    }
}
