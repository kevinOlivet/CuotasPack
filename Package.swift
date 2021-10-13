// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CuotasPack",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CuotasPack",
            targets: ["CuotasPack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kevinOlivet/CommonsPack.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/kevinOlivet/UIElementsPack.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "CuotasPack",
            dependencies: ["CommonsPack", "UIElementsPack"],
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "CuotasPackTests",
            dependencies: ["CuotasPack"]),
    ]
)
