# Composing Directories

A declarative API for creating and managing files and folders in Swift.

## Overview

Calligraphy provides a powerful and type-safe API for composing directories and their contents. The library offers both built-in types for common use cases and the ability to create custom directory content types.

## Built-in Types

### Files

The `File` type allows you to create both text and data files:

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

The `Folder` type enables you to create nested directory structures:

```swift
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
    }
    Folder("Sources") {
        File("main.swift") {
            "print(\"Hello, World!\")"
        }
    }
}
```

## Creating Custom Types

### Custom Directories

You can create custom directory types by conforming to the `Directory` protocol:

```swift
struct MyProject: Directory {
    let name = "MyProject"
    
    var body: some DirectoryContent {
        File("README.md") {
            "# My Project"
        }
        Folder("Sources") {
            File("main.swift") {
                "print(\"Hello, World!\")"
            }
        }
    }
}
```

### Custom Data Files

For binary data files, conform to the `DataFile` protocol:

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

## Writing to Disk

All directory content types can be written to disk using the `write(to:)` method:

```swift
let project = MyProject()
try await project.write(to: URL(fileURLWithPath: "/path/to/project"))
```

## Relationship to Other Builders

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

## Best Practices

1. Use meaningful names for files and folders
2. Keep directory structures shallow when possible
3. Use custom types for reusable directory patterns
4. Leverage the type system to ensure correct composition
5. Use async/await for disk operations
