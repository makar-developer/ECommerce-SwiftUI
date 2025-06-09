import ProjectDescription

let project = Project(
    name: "ProfileFeature",
    targets: [
        .target(
            name: "ProfileFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ecommerce.profile.feature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/ProfileFeature/**"],
            dependencies: [
                .project(target: "ProfilePresentation", path: "../ProfileDependencies"),
                .project(target: "ProfileDomain", path: "../ProfileDependencies"),
                .project(target: "ProfileRepositoryProtocol", path: "../ProfileDependencies"),
                .project(target: "ProfileRepository", path: "../ProfileDependencies"),
                .project(target: "CoreDependencies", path: "../Core")
            ]
        ),
        .target(
            name: "ProfileFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ecommerce.profile.feature.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/ProfileFeatureTests/**"],
            dependencies: [
                .target(name: "ProfileFeature")
            ]
        )
    ]
)
