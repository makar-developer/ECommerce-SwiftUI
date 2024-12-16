import SwiftUI
import CoreEntities
public struct ProfileCoordinatorView: View {
    @StateObject private var coordinator: ProfileCoordinator

    public init(container: ProfileDIContainerProtocol, user: User, onLogout: @escaping () -> Void) {
        _coordinator = StateObject(wrappedValue: ProfileCoordinator(container: container, user: user, onLogout: onLogout))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: .profile)
                .navigationDestination(for: ProfileScreen.self) { screen in
                    coordinator.build(screen: screen)
                }
        }
    }
}
