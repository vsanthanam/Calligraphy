# Calligraphy

[![MIT License](https://img.shields.io/github/license/vsanthanam/Calligraphy)](https://github.com/vsanthanam/Calligraphy/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/vsanthanam/Calligraphy?include_prereleases)](https://github.com/vsanthanam/Calligraphy/releases)
[![Build Status](https://img.shields.io/github/check-runs/vsanthanam/Calligraphy/main)](https://github.com/vsanthanam/Calligraphy/actions)
[![Swift Version](https://img.shields.io/badge/swift-6.1-critical)](https://swift.org)
[![Documentation](https://img.shields.io/badge/Documentation-GitHub-8A2BE2)](https://usecalligraphy.com/docs/documentation/calligraphy)

A declarative library for composing strings, text, files, and folders in Swift

## Overview

Calligraphy is a SwiftUI-inspired library that provides a declarative API for composing strings, text, files, and directories in Swift. Using result builders, it makes complex text manipulation and file generation more readable and maintainable.

Create and manipulate strings with a declarative syntax:

```swift
let message = String.build {
    Line {
        "Hello"
        Space()
        "World"
    }
    "Welcome to Calligraphy!"
}
// Result: "Hello World\nWelcome to Calligraphy!"
```

Generate entire directory structures programmatically:

```swift
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
        ""
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

Without Calligraphy:

```swift
// Creating a list of items with conditionals
func createItemList(items: [String], includeHeader: Bool) -> String {
    var result = ""
    if includeHeader {
        result += "# Item List\n\n"
    }
    for (index, item) in items.enumerated() {
        result += "\(index + 1). \(item)\n"
    }
    return result
}
```

With Calligraphy:

```swift
// Creating the same list with Calligraphy
func createItemList(items: [String], includeHeader: Bool) -> String {
    String.build {
        if includeHeader {
            "# Item List"
            ""
        }
        for (index, item) in items.enumerated() {
            "\(index + 1). \(item)"
        }
    }
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
        from: "1.0.2"
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
