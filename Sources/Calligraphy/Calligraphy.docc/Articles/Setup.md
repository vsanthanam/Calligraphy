# Project Setup

@Metadata {
    @PageImage(purpose: card, source: "getting-started.png", alt: "Setup Icon")
    @PageKind(article)
    @CallToAction(url: "https://www.github.com/vsanthanam/Calligraphy", purpose: link, label: "View on GitHub")
}

Add Calligraphy to an existing Xcode Project or Swift Package.

## Add to an Xcode Project via SPM

To add Calligraphy as a dependency to an Xcode Project, open the project in Xcode and perform the following steps:

1. Choose `File` → `Add Packages...`

2. Enter package URL `https://github.com/vsanthanam/Calligraphy.git` and select your release of choice.

## Add to a Swift Package

To add Calligraphy as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(
        url: "https://github.com/vsanthanam/Calligraphy.git",
        from: "1.1.0"
    )
]
```

## Clone from Source

To add Calligraphy to a project without the Swift Package Manager, you can clone the repository directly from GitHub:

```shell
$ git clone https://github.com/vsanthanam/Calligraphy.git
```

From there, you can copy the contents of `Sources/Calligraphy` to the destination of your choice.

You can also download a specific version of the package from the [GitHub Releases](https://github.com/vsanthanam/Calligraphy/releases) page, or from the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/Calligraphy).

@Small {
    Calligraphy is available under the [MIT license](https://en.wikipedia.org/wiki/MIT_License). See the [LICENSE](https://github.com/vsanthanam/Calligraphy/blob/main/LICENSE) file for more information.
}
