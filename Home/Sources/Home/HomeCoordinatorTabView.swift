import CoreEntities
import ProductCartFeature
import ProductDiscoverFeature
import ProductSearchFeature
import ProfileFeature
import SwiftUI

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
                container: container.makeProductDiscoverDIContainer(),
                cartContainer: container.makeCartDIContainer(),
                imageCacheContainer: container.imageCacheContainer,
                productHistoryContainer: container.makeProductHistoryDIContainer(),
                user: user
            )
            .tabItem {
                Label(String(localized: "Home"), systemImage: "house")
            }

            ProductSearchCoordinatorView(
                container: container.makeProductSearchDIContainer(),
                cartContainer: container.makeCartDIContainer(),
                imageCacheContainer: container.imageCacheContainer,
                productHistoryContainer: container.makeProductHistoryDIContainer(),
                user: user
            )
            .tabItem {
                Label(String(localized: "Search"), systemImage: "magnifyingglass")
            }

            ProductCartCoordinatorView(
                container: container.makeCartDIContainer(),
                user: user
            )
            .tabItem {
                Label(String(localized: "Cart"), systemImage: "cart")
            }

            ProfileCoordinatorView(
                container: container.makeProfileDIContainer(),
                imageContainer: container.imageCacheContainer,
                productHistoryContainer: container.makeProductHistoryDIContainer(),
                cartContainer: container.makeCartDIContainer(),
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
