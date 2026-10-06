// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility")
]

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
            url: "https://github.com/apple/swift-collections.git",
            from: "1.4.1"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-syntax",
            from: "603.0.2"
        )
    ],
    targets: [
        .target(
            name: "Calligraphy",
            dependencies: [
                "CalligraphyCompilerPlugin"
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CalligraphyTests",
            dependencies: [
                "Calligraphy",
                .product(
                    name: "Collections",
                    package: "swift-collections"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .macro(
            name: "CalligraphyCompilerPlugin",
            dependencies: [
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftCompilerPlugin",
                    package: "swift-syntax"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CalligraphyCompilerPluginTests",
            dependencies: [
                "CalligraphyCompilerPlugin",
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                )
            ],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v6]
)
