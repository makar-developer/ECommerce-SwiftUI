// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WelcomeDependencies",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "WelcomePresentation",
            targets: ["WelcomePresentation"]),
        .library(
            name: "WelcomeDomain",
            targets: ["WelcomeDomain"]),
        .library(
            name: "WelcomeRepositoryProtocol",
            targets: ["WelcomeRepositoryProtocol"]),
        .library(
            name: "WelcomeData",
            targets: ["WelcomeData"])
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "WelcomePresentation",
            dependencies: [
                "WelcomeDomain",
                .product(name: "Core", package: "Core"),
                .product(name: "CoreEntities", package: "Core")
            ],
            path: "Sources/Layers/WelcomePresentation"
        ),
        .target(
            name: "WelcomeDomain",
            dependencies: [
                "WelcomeRepositoryProtocol",
                .product(name: "Core", package: "Core"),
                .product(name: "CoreEntities", package: "Core")
            ],
            path: "Sources/Layers/WelcomeDomain"
        ),
        .target(
            name: "WelcomeRepositoryProtocol",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "CoreEntities", package: "Core")
            ],
            path: "Sources/Layers/WelcomeRepositoryProtocol"
        ),
        .target(
            name: "WelcomeData",
            dependencies: [
                "WelcomeRepositoryProtocol",
                .product(name: "Core", package: "Core"),
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreDataSources", package: "Core")
            ],
            path: "Sources/Layers/WelcomeData"
        )
    ]
)
