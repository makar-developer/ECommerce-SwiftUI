import SwiftUI
import WelcomeFeature
import CoreEntities
import Home
import CoreUseCases
final class AppCoordinator: ObservableObject {
    @Published var fullScreenCoverFeature: Feature?

    private let container: AppDIContainerProtocol
    private var welcomeFeatureIdentifier: UUID = UUID()

    init(container: AppDIContainerProtocol) {
        self.container = container
    }

    func presentFeature(_ feature: Feature) {
        DispatchQueue.main.async {
            self.fullScreenCoverFeature = feature
        }
    }
    
    func presentMain(_ user: User) {
        presentFeature(.main(user))
    }

    func presentWelcome() {
        welcomeFeatureIdentifier = UUID()
        presentFeature(.welcome(id: welcomeFeatureIdentifier))
    }
    
    func dismissFeature() {
        DispatchQueue.main.async {
            self.fullScreenCoverFeature = nil
        }
    }
    
    func getSignedInUser() async -> User? {
        do {
            return try await container.welcomeDIContainer.getSignedInUserUseCase.execute()
        } catch {
            print("Error accessing User in Keychain")
            return nil
        }
    }
    
    @ViewBuilder
    func buildRootView() -> some View {
        EmptyView()
            .task { [weak self] in
                if let signedInUser = await self?.getSignedInUser() {
                    self?.presentMain(signedInUser)
                } else {
                    self?.presentWelcome()
                }
            }
    }

    @ViewBuilder
    func build(feature: Feature) -> some View {
        switch feature {
        case .welcome(let id):
            WelcomeCoordinatorView(
                container: container.welcomeDIContainer,
                userDataContainer: container.userDataDIContainer,
                onNavigation: { [weak self] user in
                    self?.presentMain(user)
                }
            ).id(id)
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
