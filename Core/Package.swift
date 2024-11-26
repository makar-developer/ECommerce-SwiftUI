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
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)

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
