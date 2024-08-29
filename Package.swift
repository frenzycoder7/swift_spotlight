// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift_spotlight",
    platforms: [
        .iOS(.v14), // Adjust to your minimum supported version
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift_spotlight",
            targets: ["swift_spotlight"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift_spotlight"),
        .testTarget(
            name: "swift_spotlightTests",
            dependencies: ["swift_spotlight"]),
    ]
)
