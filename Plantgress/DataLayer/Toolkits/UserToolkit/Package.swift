// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserToolkit",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserToolkit",
            targets: ["UserToolkit"]),
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain"),
        .package(name: "FirebaseFirestoreProvider", path: "../../Providers/FirebaseFirestoreProvider"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseFirestoreProvider", package: "FirebaseFirestoreProvider"),
            ]
        ),
        .testTarget(
            name: "UserToolkitTests",
            dependencies: ["UserToolkit"]
        ),
    ]
)
