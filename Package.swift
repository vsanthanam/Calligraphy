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
            name: "Calligraphy",
            targets: [
                "Calligraphy"
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
        )
    ],
    targets: [
        .target(
            name: "Calligraphy",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "CalligraphyTests",
            dependencies: [
                "Calligraphy"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        )
    ]
)
