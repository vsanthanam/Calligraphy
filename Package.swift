// swift-tools-version: 6.2
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
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin",
            from: "1.4.3"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            exact: "0.58.5"
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            exact: "1.3.0"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-syntax",
            exact: "602.0.0"
        )
    ],
    targets: [
        .target(
            name: "Calligraphy",
            dependencies: [
                "CalligraphyCompilerPlugin"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .treatAllWarnings(as: .error)
            ]
        ),
        .testTarget(
            name: "CalligraphyTests",
            dependencies: [
                "Calligraphy",
                .product(name: "Collections", package: "swift-collections")
            ],
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .treatAllWarnings(as: .error)
            ]
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
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .treatAllWarnings(as: .error)
            ]
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
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .treatAllWarnings(as: .error)
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
