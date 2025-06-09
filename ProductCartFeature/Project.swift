import ProjectDescription

let project = Project(
    name: "ProductCartFeature",
    targets: [
        .target(
            name: "ProductCartFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productcart.feature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductCartFeature/**"],
            dependencies: [
                .project(target: "ProductCartPresentation", path: "../ProductCartDependencies"),
                .project(target: "CoreDependencies", path: "../Core")
            ]
        ),
        .target(
            name: "ProductCartFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.productcart.feature.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/ProductCartFeatureTests/**"],
            dependencies: [
                .target(name: "ProductCartFeature")
            ]
        )
    ]
)
