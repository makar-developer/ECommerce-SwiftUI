// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreEntities",
            targets: ["CoreEntities"]),
        .library(
            name: "CoreRepositories",
            targets: ["CoreRepositories"]),
        .library(
            name: "CoreStyleguide",
            targets: ["CoreStyleguide"]),
        .library(
            name: "CoreUseCases",
            targets: ["CoreUseCases"]),
        .library(
            name: "CoreDataSources",
            targets: ["CoreDataSources"]),
        .library(
            name: "CoreDependencies",
            targets: ["CoreDependencies"]),
        .library(
            name: "CoreTestHelpers",
            targets: ["CoreTestHelpers"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: []
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: [
                "Core",
                "CoreEntities",
                "CoreDataSources",
                "CoreRepositories",
                "CoreUseCases",
                "CoreTestHelpers",
                "CoreStyleguide"
            ]
        ),
        .target(
            name: "CoreEntities",
            dependencies: []
        ),
        .target(
            name: "CoreRepositories",
            dependencies: [
            "CoreEntities",
            "CoreDataSources"
            ]
        ),
        .target(
            name: "CoreStyleguide",
            dependencies: [
            "CoreUseCases",
            "CoreTestHelpers",
            "Core"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CoreUseCases",
            dependencies: [
            "CoreEntities",
            "CoreRepositories"
            ]
        ),
        .target(
            name: "CoreDependencies",
            dependencies: [
            "CoreEntities",
            "CoreRepositories",
            "CoreUseCases",
            "CoreDataSources"
            ]
        ),
        .target(
            name: "CoreDataSources",
            dependencies: [
            "CoreEntities"
            ],
            path: "Sources/CoreDataSources",

            resources: [
                .process("CoreData/Models/UserData.xcdatamodeld")
            ]
        ),
        .target(
            name: "CoreTestHelpers",
            dependencies: [
            "CoreEntities"
            ]
        )
    ]
)
