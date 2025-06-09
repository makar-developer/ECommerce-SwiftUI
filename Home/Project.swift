import ProjectDescription

let project = Project(
    name: "Home",
    targets: [
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.home",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Home/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreDependencies", path: "../Core"),
                .project(target: "ProductDiscoverFeature", path: "../ProductDiscoverFeature"),
                .project(target: "ProductSearchFeature", path: "../ProductSearchFeature"),
                .project(target: "ProductCartFeature", path: "../ProductCartFeature"),
                .project(target: "ProfileFeature", path: "../ProfileFeature")
            ]
        ),
        .target(
            name: "HomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.home.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/HomeTests/**"],
            dependencies: [
                .target(name: "Home")
            ]
        )
    ]
)
