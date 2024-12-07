// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreEntities",
            targets: ["CoreEntities"]),
        .library(
            name: "CoreHelpers",
            targets: ["CoreHelpers"]),
        .library(
            name: "CoreRepositories",
            targets: ["CoreRepositories"]),
        .library(
            name: "CoreStyleguide",
            targets: ["CoreStyleguide"]),
        .library(
            name: "CoreUseCases",
            targets: ["CoreUseCases"]),
   
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: []
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
        .target(
            name: "CoreEntities",
            dependencies: []
        ),
        .target(
            name: "CoreHelpers",
            dependencies: []
        ),
        .target(
            name: "CoreRepositories",
            dependencies: [],
            path: "Sources/CoreRepositories",
            resources: [
                .process("CoreData/Models/Cart.xcdatamodeld")
            ]
        ),
        .target(
            name: "CoreStyleguide",
            dependencies: [
            "CoreUseCases"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CoreUseCases",
            dependencies: [
            "CoreEntities",
            "CoreRepositories"
            ]
        )
    ]
)

//let package = Package(
//    name: "Features",
//    defaultLocalization: "en",
//    platforms: [.iOS(.v16)],
//    products: [
//        .library(
//            name: "About",
//            targets: ["About"]),
//        .library(
//            name: "Setup",
//            targets: ["Setup"]),
//        .library(
//            name: "Feed",
//            targets: ["Feed"]),
//    ],
//    dependencies: [
//        .package(path: "../Core"),
//        .package(url: "https://github.com/nmdias/FeedKit", exact: "9.1.2")
//    ],
//    targets: [
//        .target(
//            name: "About",
//            dependencies: [
//                "Core"
//            ],
//            path: "Sources/Features/About",
//            resources: [
//                .process("Data/Licenses.plist")
//            ]
//        ),
//        .target(
//            name: "Setup",
//            dependencies: [
//                "Core"
//            ],
//            path: "Sources/Features/Setup"
//        ),
//        .target(
//            name: "Feed",
//            dependencies: [
//                "Core",
//                "FeedKit"
//            ],
//            path: "Sources/Features/Feed"
//        )
//    ]
//)

//import PackageDescription
//
//let package = Package(
//    name: "Styleguide",
//    platforms: [.iOS(.v15)],
//    products: [
//        .library(
//            name: "Styleguide",
//            targets: ["Styleguide"]
//        )
//    ],
//    dependencies: [
//        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2")
//    ],
//    targets: [
//        .target(
//            name: "Styleguide",
//            dependencies: [],
//            resources: [
//                .process("Resources")
//            ],
//            plugins: [
//                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
//            ]
//        ),
//        .testTarget(
//            name: "StyleguideTests",
//            dependencies: ["Styleguide"]
//        )
//    ]
//)
