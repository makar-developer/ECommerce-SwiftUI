// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WelcomeFeature",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "WelcomeFeature",
            targets: ["WelcomeFeature"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../WelcomeDependencies")
    ],
    targets: [
        .target(
            name: "WelcomeFeature",
            dependencies: [
            "Core",
            .product(name: "CoreDependencies", package: "Core"),
            .product(name: "WelcomePresentation", package: "WelcomeDependencies"),
            .product(name: "WelcomeDomain", package: "WelcomeDependencies"),
            .product(name: "WelcomeRepositoryProtocol", package: "WelcomeDependencies"),
            .product(name: "WelcomeData", package: "WelcomeDependencies")
            ]),
        .testTarget(
            name: "WelcomeFeatureTests",
            dependencies: ["WelcomeFeature"])
    ]
)
