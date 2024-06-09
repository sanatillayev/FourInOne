// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreModel",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CoreModel",
            targets: ["CoreModel"]),
    ],
    targets: [
        .target(
            name: "CoreModel"),
        .testTarget(
            name: "CoreModelTests",
            dependencies: ["CoreModel"]),
    ]
)
