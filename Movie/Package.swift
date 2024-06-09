// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Movie",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Movie",targets: ["Movie"]),
    ],
    dependencies: [
        .package(path: "../Component"),
        .package(path: "../Router"),
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(name: "Movie", dependencies: ["Component", "Router", "CoreModel"]),
        .testTarget(name: "MovieTests",dependencies: ["Movie"]),
    ]
)
