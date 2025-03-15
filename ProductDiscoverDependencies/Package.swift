// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductDiscoverDependencies",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Core", path: "../Core"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
