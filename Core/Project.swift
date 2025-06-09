import ProjectDescription

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/Core/**"],
            dependencies: []
        ),
        .target(
            name: "CoreEntities",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.entities",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreEntities/**"],
            dependencies: []
        ),
        .target(
            name: "CoreDataSources",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.datasources",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreDataSources/**"],
            resources: [
                "Sources/CoreDataSources/CoreData/Models/**"
            ],
            dependencies: [
                .target(name: "CoreEntities")
            ]
        ),
        .target(
            name: "CoreRepositories",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.repositories",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreRepositories/**"],
            dependencies: [
                .target(name: "CoreEntities"),
                .target(name: "CoreDataSources")
            ]
        ),
        .target(
            name: "CoreStyleguide",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.styleguide",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreStyleguide/**"],
            resources: [
                "Sources/CoreStyleguide/Resources/**"
            ],
            dependencies: [
                .target(name: "CoreUseCases"),
                .target(name: "CoreTestHelpers"),
                .target(name: "Core")
            ]
        ),
        .target(
            name: "CoreUseCases",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.usecases",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreUseCases/**"],
            dependencies: [
                .target(name: "CoreEntities"),
                .target(name: "CoreRepositories")
            ]
        ),
        .target(
            name: "CoreDependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.dependencies",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreDependencies/**"],
            dependencies: [
                .target(name: "CoreEntities"),
                .target(name: "CoreRepositories"),
                .target(name: "CoreUseCases"),
                .target(name: "CoreDataSources")
            ]
        ),
        .target(
            name: "CoreTestHelpers",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.core.testhelpers",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/CoreTestHelpers/**"],
            dependencies: [
                .target(name: "CoreEntities")
            ]
        ),
        .target(
            name: "CoreTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.core.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/CoreTests/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreEntities"),
                .target(name: "CoreDataSources"),
                .target(name: "CoreRepositories"),
                .target(name: "CoreUseCases"),
                .target(name: "CoreTestHelpers"),
                .target(name: "CoreStyleguide")
            ]
        )
    ]
)
