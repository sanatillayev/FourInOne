// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Weather",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Weather",targets: ["Weather"]),
    ],
    dependencies: [
        .package(path: "../Component"),
        .package(path: "../Router"),
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(name: "Weather", dependencies: ["Component", "Router", "CoreModel"]),
        .testTarget(name: "WeatherTests",dependencies: ["Weather"]),
    ]
)
