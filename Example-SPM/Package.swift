// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Example-SPM",
    defaultLocalization: "en", 

    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Example-SPM",
            targets: ["Example-SPM"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(
            name: "Example-SPM",
            dependencies: ["EiteiQR"], path: "Example-SPM")
    ]
)
