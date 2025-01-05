// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImagesToolkit",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImagesToolkit",
            targets: ["ImagesToolkit"]),
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain"),
        .package(name: "FirebaseStorageProvider", path: "../../Providers/FirebaseStorageProvider"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ImagesToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseStorageProvider", package: "FirebaseStorageProvider"),
            ]
        ),
        .testTarget(
            name: "ImagesToolkitTests",
            dependencies: [
                "ImagesToolkit",
                .product(name: "FirebaseFirestoreProviderMocks", package: "FirebaseFirestoreProvider"),
            ]
        ),
    ]
)
