import ProjectDescription

let project = Project(
    name: "ProductCartDependencies",
    targets: [
        .target(
            name: "ProductCartPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.productcart.presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProductCartPresentation/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreStyleguide", path: "../Core")
            ]
        )
    ]
)
