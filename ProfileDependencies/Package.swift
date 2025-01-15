// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ProfileDependencies",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ProfilePresentation",
            targets: ["ProfilePresentation"]),
        .library(
            name: "ProfileDomain",
            targets: ["ProfileDomain"]),
        .library(
            name: "ProfileRepositoryProtocol",
            targets: ["ProfileRepositoryProtocol"]),
        .library(
            name: "ProfileRepository",
            targets: ["ProfileRepository"])
    ],
    dependencies: [
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(
            name: "ProfilePresentation",
            dependencies: [
                "ProfileDomain",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreUseCases", package: "Core"),
                .product(name: "CoreStyleguide", package: "Core")
            ]),
        .target(
            name: "ProfileDomain",
            dependencies: [
                "ProfileRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreUseCases", package: "Core")
            ]),
        .target(
            name: "ProfileRepositoryProtocol",
            dependencies: [
                .product(name: "CoreEntities", package: "Core")
            ]),
        .target(
            name: "ProfileRepository",
            dependencies: [
                "ProfileRepositoryProtocol",
                .product(name: "CoreEntities", package: "Core"),
                .product(name: "CoreDataSources", package: "Core")
            ])
    ]
)
