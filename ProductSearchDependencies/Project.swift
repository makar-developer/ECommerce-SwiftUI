import ProjectDescription

let project = Project(
    name: "ProductSearchDependencies",
    targets: [
        .target(
            name: "ProductSearchPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchPresentation/**"],
            dependencies: [
                .target(name: "ProductSearchDomain"),
                .target(name: "ProductSearchEntities"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreStyleguide", path: "../Core"),
                .project(target: "CoreUseCases", path: "../Core")
            ]
        ),
        .target(
            name: "ProductSearchDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchDomain/**"],
            dependencies: [
                .target(name: "ProductSearchRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "ProductSearchEntities",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.entities",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchEntities/**"],
            dependencies: []
        ),
        .target(
            name: "ProductSearchRepositoryProtocol",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.repository.protocol",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchRepositoryProtocol/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "ProductSearchRepository",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.repository",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchRepository/**"],
            dependencies: [
                .target(name: "ProductSearchRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreDataSources", path: "../Core")
            ]
        )
    ]
)
