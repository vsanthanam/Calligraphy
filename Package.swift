// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
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
        ),
        .library(
            name: "CalligraphyMacros",
            targets: [
                "CalligraphyMacros"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin",
            from: "1.4.3"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            exact: "601.0.1"
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
        ),
        .target(
            name: "CalligraphyMacros",
            dependencies: [
                "Calligraphy",
                "CalligraphyCompilerPlugin"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "CalligraphyMacrosTests",
            dependencies: [
                "CalligraphyMacros",
                "Calligraphy"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .macro(
            name: "CalligraphyCompilerPlugin",
            dependencies: [
                .product(
                    name: "SwiftSyntax",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftCompilerPlugin",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                )
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .testTarget(
            name: "CalligraphyCompilerPluginTests",
            dependencies: [
                "CalligraphyCompilerPlugin",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                )
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
    ]
)
