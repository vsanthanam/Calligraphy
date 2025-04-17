// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SiteGenerator",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.4.0"
        ),
        .package(
            url: "git@github.com:vsanthanam/Calligraphy.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "SiteGenerator",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                .product(
                    name: "Calligraphy",
                    package: "Calligraphy"
                )
            ]
        )
    ]
)
