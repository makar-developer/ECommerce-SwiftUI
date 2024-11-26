import SwiftUI
import WelcomeFeature
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            print("Path changed: \(path)")
        }
    }
    private let container: AppDIContainerProtocol
    
    init(container: AppDIContainerProtocol) {
        self.container = container
    }
    
    private func push(feature: Feature) {
        path.append(feature)
    }
    
    private func pop() {
        print("pop in AC")
        path.removeLast()
    }
    
    @ViewBuilder
    func build(feature: Feature) -> some View {
        switch feature {
        case .welcome:
            WelcomeCoordinatorView(container: container.welcomeDIContainer)
        }
    }
}

