
import SwiftUI
import CoreEntities
import ProductDiscoverFeature
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
//            RecommendedProductsCoordinatorView(
//                user: user,
//                container: container.recommendedProductsDIContainer
//            )
            ProductDiscoverCoordinatorView(container: container.productDiscoverDIContainer)
            .tabItem {
                Label("Home", systemImage: "house")
            }

//            ProductSearchCoordinatorView(
//                user: user,
//                container: container.productSearchDIContainer
//            )
            EmptyView()
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

//            ProductCartCoordinatorView(
//                user: user,
//                container: container.productCartDIContainer
//            )
            EmptyView()
            .tabItem {
                Label("Cart", systemImage: "cart")
            }

//            UserAccountCoordinatorView(
//                user: user,
//                container: container.userAccountDIContainer,
//                onLogout: onLogout
//            )
            EmptyView()
            .tabItem {
                Label("Account", systemImage: "person")
            }
        }
    }
}
