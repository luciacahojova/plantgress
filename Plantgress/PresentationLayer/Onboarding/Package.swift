// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]),
    ],
    dependencies: [
        .package(name: "UIToolKit",path: "../UIToolKit"),
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain"),
        .package(url: "https://github.com/hmlongco/Resolver.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Onboarding",
            dependencies: [
                .product(name: "UIToolkit", package: "UIToolkit"),
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "Resolver", package: "Resolver"),
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: [
                "Onboarding",
                .product(name: "UIToolkit", package: "UIToolkit"),
            ]
        ),
    ]
)
