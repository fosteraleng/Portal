// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Portal",
    platforms: [.iOS(.v15)/*, .macOS(.v13)*/],
    products: [
        .library(
            name: "Portal",
            targets: ["Portal"]),
    ],
    targets: [
        .target(
            name: "Portal",
            path: "Sources/Portal"
        ),
        .testTarget(
            name: "PortalTests",
            dependencies: ["Portal"]
        ),
    ]
)
