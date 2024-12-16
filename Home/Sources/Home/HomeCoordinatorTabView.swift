
import SwiftUI
import CoreEntities
import ProductDiscoverFeature
import ProductCartFeature
import ProductSearchFeature
import ProfileFeature
public struct HomeCoordinatorTabView: View {
    let user: User
    let container: HomeDIContainerProtocol
    let onLogout: () -> Void

    public init(user: User, container: HomeDIContainerProtocol, onLogout: @escaping () -> Void) {
        self.user = user
        self.container = container
        self.onLogout = onLogout
    }
    
    public var body: some View {
        TabView {
            ProductDiscoverCoordinatorView(container: container.productDiscoverDIContainer, cartContainer: container.cartDIContainer, imageCacheContainer: container.imageCacheContainer, user: user)
            .tabItem {
                Label("Home", systemImage: "house")
            }

            ProductSearchCoordinatorView(container: container.productSearchDIContainer, cartContainer: container.cartDIContainer, imageCacheContainer: container.imageCacheContainer, user: user)
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            ProductCartCoordinatorView(
                container: container.cartDIContainer,
                user: user
                
            )
            .tabItem {
                Label("Cart", systemImage: "cart")
            }

            ProfileCoordinatorView(
                container: container.profileDIContainer,
                user: user,
                onLogout: onLogout
            )
            .tabItem {
                Label("Account", systemImage: "person")
            }
        }
    }
}
