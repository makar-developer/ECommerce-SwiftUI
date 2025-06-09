import ProjectDescription

let project = Project(
    name: "ProductDiscoverFeature",
    targets: [
        .target(
            name: "ProductDiscoverFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productdiscover.feature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductDiscoverFeature/**"],
            dependencies: [
                .project(target: "ProductDiscoverPresentation", path: "../ProductDiscoverDependencies"),
                .project(target: "ProductDiscoverDomain", path: "../ProductDiscoverDependencies"),
                .project(target: "ProductDiscoverRepositoryProtocol", path: "../ProductDiscoverDependencies"),
                .project(target: "ProductDiscoverRepository", path: "../ProductDiscoverDependencies"),
                .project(target: "CoreDependencies", path: "../Core")
            ]
        ),
        .target(
            name: "ProductDiscoverFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.productdiscover.feature.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/ProductDiscoverFeatureTests/**"],
            dependencies: [
                .target(name: "ProductDiscoverFeature")
            ]
        )
    ]
)
