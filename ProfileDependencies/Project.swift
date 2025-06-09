import ProjectDescription

let project = Project(
    name: "ProfileDependencies",
    targets: [
        .target(
            name: "ProfilePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.profile.presentation",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProfilePresentation/**"],
            dependencies: [
                .target(name: "ProfileDomain"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreUseCases", path: "../Core"),
                .project(target: "CoreStyleguide", path: "../Core")
            ]
        ),
        .target(
            name: "ProfileDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.profile.domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProfileDomain/**"],
            dependencies: [
                .target(name: "ProfileRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreUseCases", path: "../Core")
            ]
        ),
        .target(
            name: "ProfileRepositoryProtocol",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.profile.repository.protocol",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProfileRepositoryProtocol/**"],
            dependencies: [
                .project(target: "CoreEntities", path: "../Core")
            ]
        ),
        .target(
            name: "ProfileRepository",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.profile.repository",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProfileRepository/**"],
            dependencies: [
                .target(name: "ProfileRepositoryProtocol"),
                .project(target: "CoreEntities", path: "../Core"),
                .project(target: "CoreDataSources", path: "../Core")
            ]
        )
    ]
)
