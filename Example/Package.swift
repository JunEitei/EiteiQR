// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EiteiQRScanner",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EiteiQRScanner",
            targets: ["EiteiQRScanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JunEitei/EiteiQR.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "EiteiQRScanner",
            dependencies: ["EiteiQR"])
    ],
    swiftLanguageVersions: [.v5]
)
