// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SiteGenerator",
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.4.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "SiteGenerator"
        )
    ]
)
