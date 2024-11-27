import SwiftUI
import WelcomeFeature
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
    
    func dismissFeature() {
        fullScreenCoverFeature = nil
    }

    @ViewBuilder
    func buildRootView() -> some View {
        EmptyView()
            .onAppear { [weak self] in
                // Present the feature on app launch
                self?.presentFeature(.welcome)
            }
    }

    @ViewBuilder
    func build(feature: Feature) -> some View {
        switch feature {
        case .welcome:
            WelcomeCoordinatorView(
                container: container.welcomeDIContainer,
                onDismiss: { [weak self] in
                    self?.dismissFeature()
                }
            )
        }
    }
}

