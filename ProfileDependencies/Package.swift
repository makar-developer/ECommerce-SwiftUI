// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

//import PackageDescription
//
//let package = Package(
//    name: "ProfileDependencies",
//    products: [
//        // Products define the executables and libraries a package produces, and make them visible to other packages.
//        .library(
//            name: "ProfileDependencies",
//            targets: ["ProfileDependencies"]),
//    ],
//    dependencies: [
//        // Dependencies declare other packages that this package depends on.
//        // .package(url: /* package url */, from: "1.0.0"),
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages this package depends on.
//        .target(
//            name: "ProfileDependencies",
//            dependencies: []),
//        .testTarget(
//            name: "ProfileDependenciesTests",
//            dependencies: ["ProfileDependencies"]),
//    ]
//)

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
                .product(name: "CoreUseCases", package: "Core")
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
