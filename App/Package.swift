// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [

        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [

        .package(path: "../Core"),
        .package(path: "../WelcomeFeature"),
        .package(path: "../Home"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "Core",
                "WelcomeFeature",
                "Home",
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]
        ),
    ]
)
