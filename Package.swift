// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EiteiQR",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EiteiQR",
            targets: ["EiteiQR"]),
    ],
    targets: [
        .target(
            name: "EiteiQR")
    ],
    swiftLanguageVersions: [.v5]
)
