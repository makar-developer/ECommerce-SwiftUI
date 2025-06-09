import ProjectDescription

let project = Project(
    name: "ProductSearchFeature",
    targets: [
        .target(
            name: "ProductSearchFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productsearch.feature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductSearchFeature/**"],
            dependencies: [
                .project(target: "ProductSearchPresentation", path: "../ProductSearchDependencies"),
                .project(target: "ProductSearchDomain", path: "../ProductSearchDependencies"),
                .project(target: "ProductSearchEntities", path: "../ProductSearchDependencies"),
                .project(target: "ProductSearchRepositoryProtocol", path: "../ProductSearchDependencies"),
                .project(target: "ProductSearchRepository", path: "../ProductSearchDependencies"),
                .project(target: "CoreDependencies", path: "../Core")
            ]
        ),
        .target(
            name: "ProductSearchFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.productsearch.feature.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/ProductSearchFeatureTests/**"],
            dependencies: [
                .target(name: "ProductSearchFeature")
            ]
        )
    ]
)
