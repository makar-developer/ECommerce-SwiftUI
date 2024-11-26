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
            name: "WelcomeEntities",
            targets: ["WelcomeEntities"]),
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
        // Presentation Layer
        .target(
            name: "WelcomePresentation",
            dependencies: [
                "WelcomeDomain",
                .product(name: "Core", package: "Core")
            ],
            path: "Sources/Layers/WelcomePresentation"
        ),
        // Entities Layer
        .target(
            name: "WelcomeEntities",
            dependencies: [

            ],
            path: "Sources/Layers/WelcomeEntities"
        ),
        // Domain Layer
        .target(
            name: "WelcomeDomain",
            dependencies: [
                "WelcomeRepositoryProtocol",
                "WelcomeEntities",
                .product(name: "Core", package: "Core")
            ],
            path: "Sources/Layers/WelcomeDomain"
        ),
        
        // Repository Protocol Layer
        .target(
            name: "WelcomeRepositoryProtocol",
            dependencies: [
                "WelcomeEntities",
                .product(name: "Core", package: "Core")
            ],
            path: "Sources/Layers/WelcomeRepositoryProtocol"
        ),
        // Data Layer
        .target(
            name: "WelcomeData",
            dependencies: [
                "WelcomeRepositoryProtocol",
                "WelcomeEntities",
                .product(name: "Core", package: "Core")
            ],
            path: "Sources/Layers/WelcomeData"
        )
    ]
)
