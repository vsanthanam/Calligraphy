# Calligraphy

[![MIT License](https://img.shields.io/github/license/vsanthanam/Calligraphy)](https://github.com/vsanthanam/Calligraphy/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/vsanthanam/Calligraphy?include_prereleases)](https://github.com/vsanthanam/Calligraphy/releases)
[![Build Status](https://img.shields.io/github/check-runs/vsanthanam/Calligraphy/main)](https://github.com/vsanthanam/Calligraphy/actions)
[![Swift Version](https://img.shields.io/badge/swift-6.1%20%7C%206.2%20%7C%206.3-critical)](https://swift.org)
[![Xcode](https://img.shields.io/badge/xcode-26.4.1-blue)](https://developer.apple.com/xcode/)
[![Documentation](https://img.shields.io/badge/Documentation-GitHub-8A2BE2)](https://usecalligraphy.com/docs/documentation/calligraphy)

A declarative library for composing strings, text, files, and folders in Swift

## Overview

Calligraphy is SwiftUI for strings, files, and folders. Components conform to `StringComponent` the way views conform to `View`, `@StringBuilder` composes them like `@ViewBuilder`, and modifiers chain the same way. The same pattern extends to directory trees via `DirectoryContent` and `@DirectoryContentBuilder`.

Compose a multi-line string from components:

```swift
let message = String.build {
    Line {
        "Hello,"
        Space()
        "World"
    }
    Blank()
    "Welcome to Calligraphy."
}
// Hello, World
//
// Welcome to Calligraphy.
```

Generate entire directory structures programmatically:

```swift
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
        Blank()
        "A sample project created with Calligraphy"
    }
    Folder("Sources") {
        File("main.swift") {
            Line {
                "print("
                Quoted {
                    "Hello, World!"
                }
                ")"
            }
        }
    }
}

// Write to disk
try await project.write(to: URL(fileURLWithPath: "/path/to/output"))
```

Calligraphy's declarative approach offers significant advantages over traditional imperative string construction.

Conditional sections, without Calligraphy:

```swift
func releaseNotes(version: String, features: [String], fixes: [String]) -> String {
    var notes = "# v\(version)\n"
    if !features.isEmpty {
        notes += "\n## Features\n"
        for feature in features {
            notes += "- \(feature)\n"
        }
    }
    if !fixes.isEmpty {
        notes += "\n## Bug Fixes\n"
        for fix in fixes {
            notes += "- \(fix)\n"
        }
    }
    return notes.trimmingCharacters(in: .newlines)
}
```

With Calligraphy:

```swift
@StringBuilder
func releaseNotes(version: String, features: [String], fixes: [String]) -> String {
    "# v\(version)"
    if !features.isEmpty {
        ""
        "## Features"
        for feature in features {
            "- \(feature)"
        }
    }
    if !fixes.isEmpty {
        ""
        "## Bug Fixes"
        for fix in fixes {
            "- \(fix)"
        }
    }
}
```

Nested indentation, without Calligraphy:

```swift
func renderHandler(name: String, paths: [String]) -> String {
    var result = "struct \(name) {\n"
    result += "    func handle(_ path: String) {\n"
    result += "        switch path {\n"
    for path in paths {
        result += "        case \"\(path)\":\n"
        result += "            dispatch(\"\(path)\")\n"
    }
    result += "        }\n"
    result += "    }\n"
    result += "}"
    return result
}
```

With Calligraphy:

```swift
@StringBuilder
func renderHandler(name: String, paths: [String]) -> String {
    "struct \(name) {"
    Tabbed {
        "func handle(_ path: String) {"
        Tabbed {
            "switch path {"
            for path in paths {
                "case \"\(path)\":"
                Tabbed {
                    "dispatch(\"\(path)\")"
                }
            }
            "}"
        }
        "}"
    }
    "}"
}
```

The declarative approach more closely resembles the final output structure, making it easier to read, maintain, and modify. It also eliminates common issues like missing newlines or inconsistent formatting that plague imperative string construction. This style of API is significantly more readable and maintainable than concatenating strings, using templating languages, or manually creating file structures, especially for complex code generation or configuration tasks.

## Installation

Calligraphy currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/). 

To add Calligraphy as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(
        url: "https://github.com/vsanthanam/Calligraphy.git",
        from: "1.2.5"
    )
]
```

To add Calligraphy as a dependency to an Xcode Project: 

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/Calligraphy.git` and select your release and of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

## Usage & Documentation

Calligraphy's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository as a DocC archive. The latest version is hosted on [GitHub Pages](https://pages.github.com) and is available [here](https://usecalligraphy.com/docs/documentation/calligraphy).

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/Calligraphy)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FCalligraphy%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/Calligraphy)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FCalligraphy%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/Calligraphy)

Explore [the documentation](https://usecalligraphy.com/docs/documentation/calligraphy) for more details.

## License

**Calligraphy** is available under the [MIT license](https://en.wikipedia.org/wiki/MIT_License). See the [LICENSE](https://github.com/vsanthanam/Calligraphy/blob/main/LICENSE) file for more information.
