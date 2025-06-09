import ProjectDescription

let project = Project(
    name: "WelcomeFeature",
    targets: [
        .target(
            name: "WelcomeFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.welcomefeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/WelcomeFeature/**"],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreDependencies", path: "../Core"),
                .project(target: "WelcomePresentation", path: "../WelcomeDependencies"),
                .project(target: "WelcomeDomain", path: "../WelcomeDependencies"),
                .project(target: "WelcomeRepositoryProtocol", path: "../WelcomeDependencies"),
                .project(target: "WelcomeData", path: "../WelcomeDependencies")
            ]
        ),
        .target(
            name: "WelcomeFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.welcomefeature.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/WelcomeFeatureTests/**"],
            dependencies: [
                .target(name: "WelcomeFeature")
            ]
        )
    ]
)
