// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIToolkit",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UIToolkit",
            targets: ["UIToolkit"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/hmlongco/Resolver.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UIToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "Resolver", package: "Resolver"),
            ]
        ),
        .testTarget(
            name: "UIToolkitTests",
            dependencies: ["UIToolkit"],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
    ]
)
