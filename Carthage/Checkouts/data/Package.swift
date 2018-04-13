// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CentigradeData",
    products: [
        .library(name: "CentigradeData", targets: ["CentigradeData"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "CentigradeData", dependencies: [ "SwiftProtobuf" ]),
        .testTarget(name: "CentigradeDataTests", dependencies: ["CentigradeData"]),
    ]
)
