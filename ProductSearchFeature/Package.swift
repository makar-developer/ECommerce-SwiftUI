// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductSearchFeature",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ProductSearchFeature",
            targets: ["ProductSearchFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../ProductSearchDependencies"),
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "ProductSearchFeature",
            dependencies: [
                .product(name: "ProductSearchPresentation", package: "ProductSearchDependencies"),
                .product(name: "ProductSearchDomain", package: "ProductSearchDependencies"),
                .product(name: "ProductSearchEntities", package: "ProductSearchDependencies"),
                .product(name: "ProductSearchRepositoryProtocol", package: "ProductSearchDependencies"),
                .product(name: "ProductSearchRepository", package: "ProductSearchDependencies"),
                .product(name: "CoreDependencies", package: "Core"),
            ]
        ),
        .testTarget(
            name: "ProductSearchFeatureTests",
            dependencies: ["ProductSearchFeature"]
        ),
    ]
)
