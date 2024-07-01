// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EiteiQR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EiteiQR",
            targets: ["EiteiQR"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dagronf/qrcode.git", from: "20.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "EiteiQR",
            dependencies: [
                .product(name: "QRCode", package: "qrcode"),
                "SnapKit"
            ],
            path: "Sources/EiteiQR",
            resources: [
                .copy("Sources/Resource")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
