// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YandexMapWarepper",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "YandexMapWarepper",
            targets: ["YandexMapWarepper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/c-villain/YandexMapsMobileLite", from: "4.6.1")
    ],
    targets: [
        .target(name: "YandexMapWarepper",
                dependencies: [
                    .product(name: "YandexMapsMobile", package: "YandexMapsMobileLite"),
                ],
//                resources: [
//                  .process("Resources"),
//                ],
                linkerSettings: [
                    .linkedFramework("CoreLocation"),
                    .linkedFramework("CoreTelephony"),
                    .linkedFramework("SystemConfiguration"),
                    .linkedFramework("Security"),
                    .linkedFramework("CoreMotion"),
                    .linkedFramework("CoreTelephony"),
                    .linkedFramework("DeviceCheck"),
                    .linkedLibrary("c++"),
                    .linkedLibrary("resolv"),
                    .unsafeFlags(["-ObjC"]),
                ])
    ]
)
