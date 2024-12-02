import SwiftUI
import WelcomeFeature
import CoreEntities
import Home

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var fullScreenCoverFeature: Feature?

    private let container: AppDIContainerProtocol

    init(container: AppDIContainerProtocol) {
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

    @ViewBuilder
    func buildRootView() -> some View {
        EmptyView()
            .onAppear { [weak self] in
                // Present the welcome feature on app launch
                self?.presentWelcome()
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
            EmptyView()
        }
    }
}

