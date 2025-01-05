// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseFirestoreProvider",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FirebaseFirestoreProvider",
            targets: ["FirebaseFirestoreProvider"]
        ),
        .library(
            name: "FirebaseFirestoreProviderMocks",
            targets: ["FirebaseFirestoreProviderMocks"]
        ),
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain"),
        .package(name: "Utilities", path: "../../../DomainLayer/Utilities"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.6.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FirebaseFirestoreProvider",
            dependencies: [
                .product(name: "Utilities", package: "Utilities"),
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "FirebaseFirestoreProviderMocks",
            dependencies: ["FirebaseFirestoreProvider"]
        )
    ]
)
