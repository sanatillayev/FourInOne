// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Component",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Component",targets: ["Component"]),
    ],
    targets: [
        .target(name: "Component"),
        .testTarget(name: "ComponentTests",dependencies: ["Component"]),
    ]
)
