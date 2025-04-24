# Composing Directories

@Metadata {
    @PageImage(purpose: card, source: "composing-directories.png", alt: "Declarative file with folder illustration")
    @PageKind(article)
}

Use @`DirectoryContentBuilder` to compose complex, nested directory structures and write them to disk.

## Overview

Calligraphy provides a powerful and type-safe API for composing directories and their contents. The library offers both built-in types for common use cases and the ability to create custom directory content types.

### Files

The ``File`` type allows you to create both text and data files:

```swift
// Create a text file
let textFile = File("README.md") {
    "# My Project"
    ""
    "This is a sample project."
}

// Create a data file
let dataFile = File("config.json") {
    Data("{\"key\": \"value\"}".utf8)
}
```

### Folders

The ``Folder`` type enables you to create nested directory structures:

```swift
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
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
```

### Custom Directory Content Types

You can create reusabe file and folder types that represent higher level concepts, such as a particular kind of file template or an asset bundle. To do this, you can create types that conform to the `TextFile`, `DataFile`, or `Directory` protocols.

#### Custom Text Files

For text files, conform to the ``TextFile`` protocol:

```swift
struct ReadmeFile: DataFile {

    let name = "README.md"
    
    var body: some StringComponent {
        "# My Project"
    }

}
```

#### Custom Data Files

For binary data files, conform to the ``DataFile`` protocol:

```swift
struct ConfigFile: DataFile {

    let name = "config.bin"
    
    var body: some DataComponent {
        0x01  // Version
        0x02  // Flags
        0x03  // Data
    }

}
```

#### Custom Directories

You can create custom directory types by conforming to the ``Directory`` protocol:

```swift
struct MyProject: Directory {

    let name = "MyProject"
    
    var body: some DirectoryContent {
        ReadmeFile()
        ConfigFile()
    }

}
```

### Combining with @StringBuilder and @DataBuilder

The directory composition API works seamlessly with other Calligraphy builders:

- `@StringBuilder` for text content
- `@DataBuilder` for binary data
- `@DirectoryContentBuilder` for directory structure

This allows you to compose complex directory structures with rich content:

```swift
struct Documentation: Directory {
    let name = "Documentation"
    
    var body: some DirectoryContent {
        File("README.md") {
            "# Documentation"
            ""
            "This is the documentation for our project."
        }
        Folder("API") {
            File("API.md") {
                "# API Reference"
                ""
                "Detailed API documentation..."
            }
        }
    }
}
```

### Writing to Disk

All directory content types can be written to disk using the ``DirectoryContent/write(to:shouldOverwrite:)`` method:

```swift
let project = Files {
    Folder("Project") {
        Documentation()
        MyProject()
    }
    File("License", fileExtension: "txt") {
        "License Here"
    }
}
try await project.write(to: URL(fileURLWithPath: "/path/to/project"))
```
