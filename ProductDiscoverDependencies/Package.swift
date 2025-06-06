// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductDiscoverDependencies",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ProductDiscoverPresentation",
            targets: ["ProductDiscoverPresentation"]
        ),
        .library(
            name: "ProductDiscoverDomain",
            targets: ["ProductDiscoverDomain"]
        ),
        .library(
            name: "ProductDiscoverRepositoryProtocol",
            targets: ["ProductDiscoverRepositoryProtocol"]
        ),
        .library(
            name: "ProductDiscoverRepository",
            targets: ["ProductDiscoverRepository"]
        ),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
    ],
    targets: [
        .target(
            name: "ProductDiscoverPresentation",
            dependencies: [
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreStyleguide", package: "Core"),
                .product(name: "CoreRepositories", package: "Core"),
            ]
        ),
        .target(
            name: "ProductDiscoverDomain",
            dependencies: [
                "ProductDiscoverRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core"),
            ]
        ),
        .target(
            name: "ProductDiscoverRepositoryProtocol",
            dependencies: [
                .product(name: "CoreEntities", package: "Core"),
            ]
        ),
        .target(
            name: "ProductDiscoverRepository",
            dependencies: [
                "ProductDiscoverRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreRepositories", package: "Core"),
            ]
        ),
    ]
)
