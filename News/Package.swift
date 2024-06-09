// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "News",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "News",targets: ["News"]),
    ],
    dependencies: [
        .package(path: "../Component"),
        .package(path: "../Router"),
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(name: "News", dependencies: ["Component", "Router", "CoreModel"]),
        .testTarget(name: "NewsTests",dependencies: ["News"]),
    ]
)
