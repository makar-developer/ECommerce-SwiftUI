import SwiftUI
import WelcomeFeature
import CoreEntities
import Home
import CoreUseCases
final class AppCoordinator: ObservableObject {
    @Published var fullScreenCoverFeature: Feature?

    private let container: AppDIContainerProtocol

    init(container: AppDIContainerProtocol) {
        self.container = container
//        Task {
//            await getSignedInUser()
//        }
    }

    func presentFeature(_ feature: Feature) {
        fullScreenCoverFeature = feature
    }
    
    func presentMain(_ user: User) {
        presentFeature(.main(user))
    }
    
    func presentWelcome() {
        presentFeature(.welcome)
    }
    
    func dismissFeature() {
        fullScreenCoverFeature = nil
    }
    
    func getSignedInUser() async -> User? {
        do {
            return try await container.welcomeDIContainer.getSignedInUserUseCase.execute()
        } catch {
            print("Error accessing User in Keychain: \(error)")
            return nil
        }
    }
    
    @ViewBuilder
    func buildRootView() -> some View {
        EmptyView()
            .onAppear {
                Task.detached { [weak self] in
                    guard let self = self else { return }
                    if let signedInUser = await self.getSignedInUser() {
                        await MainActor.run {
                            self.presentMain(signedInUser)
                        }
                    } else {
                        await MainActor.run {
                            self.presentWelcome()
                        }
                    }
                }
            }
    }


    @ViewBuilder
    func build(feature: Feature) -> some View {
        switch feature {
        case .welcome:
            WelcomeCoordinatorView(
                container: container.welcomeDIContainer,
                onNavigation: { [weak self] user in
                    self?.presentMain(user)
                }
            )
        case .main(let user):
            HomeCoordinatorTabView(
                user: user,
                container: container.homeDIContainer,
                onLogout: { [weak self] in
                    self?.presentWelcome()
                }
            )
        }
    }
}

