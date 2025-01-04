import SwiftUI
import Core
import CoreEntities

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
                signInAction: { selectedUser in
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
