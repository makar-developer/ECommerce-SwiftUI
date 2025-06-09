import ProjectDescription

let project = Project(
    name: "WelcomeDependencies",
    targets: [
        .target(
            name: "WelcomePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.welcome.presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Layers/WelcomePresentation/**"],
            resources: ["Sources/Layers/WelcomePresentation/**/Assets.xcassets"],
            dependencies: [
                .target(name: "WelcomeDomain"),
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreUseCases", path: "../Core"),
                .project(target: "CoreStyleguide", path: "../Core")
            ]
        ),
        .target(
            name: "WelcomeDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.welcome.domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Layers/WelcomeDomain/**"],
            dependencies: [
                .target(name: "WelcomeRepositoryProtocol"),
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "WelcomeRepositoryProtocol",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.welcome.repository.protocol",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Layers/WelcomeRepositoryProtocol/**"],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "WelcomeData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.welcome.data",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Layers/WelcomeData/**"],
            dependencies: [
                .target(name: "WelcomeRepositoryProtocol"),
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreDataSources", path: "../Core")
            ]
        ),
        .target(
            name: "WelcomeDependenciesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.welcome.dependencies.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/WelcomeDependenciesTests/**"],
            dependencies: [
                .target(name: "WelcomeRepositoryProtocol"),
                .target(name: "WelcomeData"),
                .target(name: "WelcomePresentation"),
                .target(name: "WelcomeDomain"),
                .project(target: "Core", path: "../Core"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreDataSources", path: "../Core")
            ]
        )
    ]
)
