import SwiftUI
import Core
import WelcomeEntities

// MARK: - WelcomeView

public struct WelcomeView: View {
    @StateObject private var viewModel: WelcomeViewModel
    @State private var currentIndex: Int = 0 // Track the current index

    public init(viewModel: WelcomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
//        NavigationView {
            SnapCarousel(data: viewModel.users, currentIndex: $currentIndex) { user in
                GreetingCardView(
                    user: user,
                    isEditingModeEnabled: $viewModel.isEditingModeEnabled,
                    showLogoutAlert: $viewModel.showLogoutAlert,
                    logoutAction: {
                        viewModel.logoutUser(user: user)
                        adjustCurrentIndexAfterDeletion()
                    }
                )
            } createAccount: {
                print("CreateAccountTriggered")
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
                                .imageScale(.large)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
//        }
        .task {
            await viewModel.loadUsers()
        }
        .onChange(of: viewModel.users) { _ in
            adjustCurrentIndexAfterDeletion()
        }
    }

    /// Adjusts the currentIndex to ensure it's within the bounds of the users array.
    private func adjustCurrentIndexAfterDeletion() {
        DispatchQueue.main.async {
            if currentIndex >= viewModel.users.count {
                currentIndex = max(viewModel.users.count - 1, 0)
            }
        }
    }
}



