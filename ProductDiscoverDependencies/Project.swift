import ProjectDescription

let project = Project(
    name: "ProductDiscoverDependencies",
    targets: [
        .target(
            name: "ProductDiscoverPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productdiscover.presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductDiscoverPresentation/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreStyleguide", path: "../Core"),
                .project(target: "CoreRepositories", path: "../Core")
            ]
        ),
        .target(
            name: "ProductDiscoverDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productdiscover.domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductDiscoverDomain/**"],
            dependencies: [
                .target(name: "ProductDiscoverRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "ProductDiscoverRepositoryProtocol",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productdiscover.repository.protocol",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductDiscoverRepositoryProtocol/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "ProductDiscoverRepository",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productdiscover.repository",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductDiscoverRepository/**"],
            dependencies: [
                .target(name: "ProductDiscoverRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreRepositories", path: "../Core")
            ]
        )
    ]
)
