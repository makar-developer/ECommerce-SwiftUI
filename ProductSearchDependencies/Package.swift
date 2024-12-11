// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProductSearchDependencies",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ProductSearchPresentation",
            targets: ["ProductSearchPresentation"]),
        .library(
            name: "ProductSearchDomain",
            targets: ["ProductSearchDomain"]),
        .library(
            name: "ProductSearchEntities",
            targets: ["ProductSearchEntities"]),
        .library(
            name: "ProductSearchRepositoryProtocol",
            targets: ["ProductSearchRepositoryProtocol"]),
        .library(
            name: "ProductSearchRepository",
            targets: ["ProductSearchRepository"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ProductSearchPresentation",
            dependencies: [
                "ProductSearchDomain",
                "ProductSearchEntities",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreStyleguide", package: "Core"),
                .product(name: "CoreUseCases", package: "Core")
            ]),
        .target(
            name: "ProductSearchDomain",
            dependencies: [
                "ProductSearchRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core")
            ]),
        .target(
            name: "ProductSearchEntities",
            dependencies: [
            ]),
        .target(
            name: "ProductSearchRepositoryProtocol",
            dependencies: [
                .product(name: "CoreEntities", package: "Core")
            ]),
        .target(
            name: "ProductSearchRepository",
            dependencies: [
                "ProductSearchRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreRepositories", package: "Core")
            ]),
    ]
)

