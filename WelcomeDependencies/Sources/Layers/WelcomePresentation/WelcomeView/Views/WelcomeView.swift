import Core
import CoreEntities
import SwiftUI

// MARK: - WelcomeView

public struct WelcomeView: View {
    @StateObject private var viewModel: WelcomeViewModel
    @State private var currentIndex: Int = 0

    public init(viewModel: WelcomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        SnapCarousel(data: viewModel.users, currentIndex: $currentIndex) { user in
            GreetingCardView(
                user: user,
                imageName: viewModel.getImage(for: user),
                isEditingModeEnabled: $viewModel.isEditingModeEnabled,
                logoutAction: { selectedUser in
                    viewModel.deleteUser(user: selectedUser)
                    adjustCurrentIndexAfterDeletion()
                },
                signInAction: { _ in
                    viewModel.signIn(user: user)
                    viewModel.showMain(user: user)
                }
            )
        } createAccount: {
            viewModel.showAuthentication()
        }
        .toolbar {
            if !viewModel.users.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.toggleEditingMode()
                        }
                    }) {
                        Image(systemName: viewModel.isEditingModeEnabled ? "arrow.backward" : "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentPrimary)
                    }
                }
            }
        }
        .background(Color.backgroundPrimary)
        .task {
            await viewModel.loadUsers()
        }
        .onChange(of: viewModel.users) { _ in
            adjustCurrentIndexAfterDeletion()
        }
    }

    @MainActor
    private func adjustCurrentIndexAfterDeletion() {
        if currentIndex >= viewModel.users.count {
            currentIndex = max(viewModel.users.count - 1, 0)
        }
    }
}

import CoreTestHelpers
import CoreUseCases
import WelcomeDomain

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockGetAllUsersUseCase = MockGetAllUsersUseCase()
        mockGetAllUsersUseCase.returnedUsers = User.getAnArrayOfThese() // Mock users

        let mockDeleteUserUseCase = MockDeleteUserUseCase()
        let mockSignInUseCase = MockSignInUseCase()
        let mockDeleteUserDataUseCase = MockDeleteUserDataUseCase()
        let mockCreateUserUseCase = MockCreateUserUseCase()
        let mockCreateUserDataUseCase = MockCreateUserDataUseCase()
        let mockFetchUserDataUseCase = MockFetchUserDataUseCase()

        // Populate fetchUserDataUseCase with mock data
        mockFetchUserDataUseCase.userDataMap = [
            UUID(uuidString: "22222222-2222-2222-2222-222222222222")!: UUID(),
            UUID(uuidString: "33333333-3333-3333-3333-333333333333")!: UUID(),
            UUID(uuidString: "44444444-4444-4444-4444-444444444444")!: nil,
        ]

        let viewModel = WelcomeViewModel(
            getAllUsersUseCase: mockGetAllUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase,
            signInUseCase: mockSignInUseCase,
            deleteUserDataUseCase: mockDeleteUserDataUseCase,
            createUserUseCase: mockCreateUserUseCase,
            createUserDataUseCase: mockCreateUserDataUseCase,
            fetchUserDataUseCase: mockFetchUserDataUseCase,
            onNavigation: { target in
                switch target {
                case .authentication:
                    print("Navigating to Authentication")
                case let .main(user):
                    print("Navigating to Main with user: \(user.name.rawValue)")
                }
            }
        )

        Task {
            await viewModel.loadUsers()
        }

        return NavigationView {
            WelcomeView(viewModel: viewModel)
        }
    }
}
