// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FanDeckOTP",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "FanDeckOTP",
            targets: ["FanDeckOTP"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FanDeckOTP",
            dependencies: []
        ),
        .testTarget(
            name: "FanDeckOTPTests",
            dependencies: ["FanDeckOTP"]
        ),
    ]
)
