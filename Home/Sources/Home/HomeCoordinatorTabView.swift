
import SwiftUI
import CoreEntities
import ProductDiscoverFeature
import ProductCartFeature
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
            ProductDiscoverCoordinatorView(container: container.productDiscoverDIContainer, cartContainer: container.cartDIContainer, user: user)
            .tabItem {
                Label("Home", systemImage: "house")
            }

//            ProductSearchCoordinatorView(
//                user: user,
//                container: container.productSearchDIContainer
//            )
            Text("SearchView")
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

//            UserAccountCoordinatorView(
//                user: user,
//                container: container.userAccountDIContainer,
//                onLogout: onLogout
//            )
            Text("AccountView")
            .tabItem {
                Label("Account", systemImage: "person")
            }
        }
    }
}
