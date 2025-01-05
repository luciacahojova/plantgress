// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeychainProvider",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KeychainProvider",
            targets: ["KeychainProvider"]
        ),
        .library(
            name: "KeychainProviderMocks",
            targets: ["KeychainProviderMocks"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KeychainProvider",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ]
        ),
        .target(
            name: "KeychainProviderMocks",
            dependencies: ["KeychainProvider"]
        )
    ]
)
