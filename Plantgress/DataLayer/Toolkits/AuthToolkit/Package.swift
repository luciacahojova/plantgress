// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthToolkit",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AuthToolkit",
            targets: ["AuthToolkit"]),
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain"),
        .package(name: "FirebaseAuthProvider", path: "../../Providers/FirebaseAuthProvider"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AuthToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseAuthProvider", package: "FirebaseAuthProvider"),
            ]
        ),
        .testTarget(
            name: "AuthToolkitTests",
            dependencies: [
                "AuthToolkit",
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseAuthProvider", package: "FirebaseAuthProvider"),
            ]
        ),
    ]
)
