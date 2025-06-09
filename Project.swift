import ProjectDescription

let project = Project(
    name: "ECommerce",
    targets: [
        .target(
            name: "ECommerce",
            destinations: .iOS,
            product: .app,
            bundleId: "com.ecommerce.app",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ECommerce/**/*.swift"],
            resources: [
                "ECommerce/**/*.xcassets",
                "ECommerce/**/*.strings"
            ],
            dependencies: [
                .project(target: "App", path: "App")
            ]
        ),
        .target(
            name: "ECommerceUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.ecommerce.uitests",
            deploymentTargets: .iOS("16.0"),
            sources: ["ECommerceUITests/**"],
            dependencies: [
                .target(name: "ECommerce")
            ]
        )
    ]
)
