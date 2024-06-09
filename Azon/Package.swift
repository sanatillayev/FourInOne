// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Azon",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Azon",targets: ["Azon"]),
    ],
    dependencies: [
        .package(path: "../Component"),
        .package(path: "../Router"),
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(name: "Azon", dependencies: ["Component", "Router", "CoreModel"]),
        .testTarget(name: "AzonTests",dependencies: ["Azon"]),
    ]
)
