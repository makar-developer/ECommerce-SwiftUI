// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [

        .library(
            name: "Home",
            targets: ["Home"]
        ),
    ],
    dependencies: [

        .package(path: "../Core"),
        .package(path: "../ProductDiscoverFeature"),
        .package(path: "../ProductSearchFeature"),
        .package(path: "../ProductCartFeature"),
        .package(path: "../ProfileFeature"),

    ],
    targets: [

        .target(
            name: "Home",
            dependencies: [
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreDependencies", package: "Core"),
                "ProductDiscoverFeature",
                "ProductSearchFeature",
                "ProductCartFeature",
                "ProfileFeature",
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        ),
    ]
)
