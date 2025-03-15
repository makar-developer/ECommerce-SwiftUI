import CoreEntities
import CoreUseCases
import Home
import SwiftUI
import WelcomeFeature

/// App-level Coordinator  - can perform navigation between each individual Feature(within the App). Feature-level Coordinator - can perform navigation between each individual Screen(within the Feature).
@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var fullScreenCoverFeature: Feature?
    
    private let container: AppDIContainerProtocol
    
    public init(container: AppDIContainerProtocol) {
        self.container = container
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
            return try await container.makeWelcomeDIContainer().makeGetSignedInUserUseCase().execute()
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
        case .welcome:
            WelcomeCoordinatorView(
                coordinator: WelcomeCoordinator(
                    container: container.makeWelcomeDIContainer(),
                    userDataContainer: container.makeUserDataDIContainer(),
                    onNavigation: { [weak self] user in
                        self?.presentMain(user)
                    }
                )
            )
            
        case let .main(user):
            HomeCoordinatorTabView(
                user: user,
                container: container.makeHomeDIContainer(),
                onLogout: { [weak self] in
                    self?.presentWelcome()
                }
            )
        }
    }
}
