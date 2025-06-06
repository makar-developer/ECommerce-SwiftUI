// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductDiscoverFeature",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ProductDiscoverFeature",
            targets: ["ProductDiscoverFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../ProductDiscoverDependencies"),
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "ProductDiscoverFeature",
            dependencies: [
                .product(name: "ProductDiscoverPresentation", package: "ProductDiscoverDependencies"),
                .product(name: "ProductDiscoverDomain", package: "ProductDiscoverDependencies"),
                .product(name: "ProductDiscoverRepositoryProtocol", package: "ProductDiscoverDependencies"),
                .product(name: "ProductDiscoverRepository", package: "ProductDiscoverDependencies"),
                .product(name: "CoreDependencies", package: "Core"),
            ]
        ),
        .testTarget(
            name: "ProductDiscoverFeatureTests",
            dependencies: ["ProductDiscoverFeature"]
        ),
    ]
)
