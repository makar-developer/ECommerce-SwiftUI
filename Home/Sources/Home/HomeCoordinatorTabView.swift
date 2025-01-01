
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
            ProductDiscoverCoordinatorView(
                container: container.productDiscoverDIContainer,
                cartContainer: container.cartDIContainer,
                imageCacheContainer: container.imageCacheContainer,
                productHistoryContainer: container.productHistoryDIContainer,
                user: user
            )
            .tabItem {
                Label(String(localized: "Home"), systemImage: "house")
            }

            ProductSearchCoordinatorView(
                container: container.productSearchDIContainer,
                cartContainer: container.cartDIContainer,
                imageCacheContainer: container.imageCacheContainer,
                productHistoryContainer: container.productHistoryDIContainer,
                user: user
            )
            .tabItem {
                Label(String(localized: "Search"), systemImage: "magnifyingglass")
            }

            ProductCartCoordinatorView(
                container: container.cartDIContainer,
                user: user
            )
            .tabItem {
                Label(String(localized: "Cart"), systemImage: "cart")
            }

            ProfileCoordinatorView(
                container: container.profileDIContainer,
                imageContainer: container.imageCacheContainer,
                productHistoryContainer: container.productHistoryDIContainer,
                cartContainer: container.cartDIContainer,
                user: user,
                onLogout: onLogout
            )
            .tabItem {
                Label(String(localized: "Account"), systemImage: "person")
            }
        }
        .accentColor(.accentPrimary)
        .background(
            Color.backgroundPrimary
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(Color.backgroundPrimary)
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.accentPrimary)
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.accentPrimary)]
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.textSecondary)
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.textSecondary)]
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
