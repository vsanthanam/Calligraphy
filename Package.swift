// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calligraphy",
    platforms: [
        .macOS(.v14),
        .macCatalyst(.v17),
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "FileBuilder",
            targets: [
                "FileBuilder"
            ]
        ),
        .library(
            name: "StringBuilder",
            targets: [
                "StringBuilder"
            ]
        ),
        .library(
            name: "DataBuilder",
            targets: [
                "DataBuilder"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin",
            from: "1.4.3"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            exact: "0.55.0"
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            exact: "1.1.4"
        )
    ],
    targets: [
        .target(
            name: "FileBuilder",
            dependencies: [
                "StringBuilder",
                "DataBuilder"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "FileBuilderTests",
            dependencies: [
                "FileBuilder"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .target(
            name: "StringBuilder",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "StringBuilderTests",
            dependencies: [
                "StringBuilder"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .target(
            name: "DataBuilder",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "DataBuilderTests",
            dependencies: [
                "DataBuilder",
                .product(name: "Collections", package: "swift-collections")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
    ]
)
