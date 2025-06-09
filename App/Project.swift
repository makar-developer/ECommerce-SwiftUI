import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.app.framework",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/App/**"],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .project(target: "WelcomeFeature", path: "../WelcomeFeature"),
                .project(target: "Home", path: "../Home")
            ]
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.app.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/AppTests/**"],
            dependencies: [
                .target(name: "App")
            ]
        )
    ]
)
