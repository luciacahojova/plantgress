// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Explore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Explore",
            targets: ["Explore"]),
    ],
    dependencies: [
        .package(path: "../UIToolKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Explore",
            dependencies: [
                .product(name: "UIToolkit", package: "UIToolkit"),
            ]
        ),
        .testTarget(
            name: "ExploreTests",
            dependencies: [
                "Explore",
                .product(name: "UIToolkit", package: "UIToolkit"),
            ]
        ),
    ]
)
