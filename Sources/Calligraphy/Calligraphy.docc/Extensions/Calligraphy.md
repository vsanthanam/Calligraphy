# ``Calligraphy``

A declarative API for composing multi-line strings, files, and folders in Swift

## Overview

Calligraphy provides a powerful and intuitive way to compose complex text structures in Swift. Drawing inspiration from SwiftUI's declarative approach, Calligraphy offers a familiar API design that will feel natural to SwiftUI developers. Whether you're building multi-line strings, generating code, or creating entire directory structures, Calligraphy's declarative API makes your code more readable and maintainable than comparative strategies, such as a templating language.

The library is organized into three main areas:

- **String Composition**: Create and manipulate strings with components like `Line`, `Lines`, and `Tabbed`. Build and compose your own `StringComponent` types and compose them into complex string structures using `@StringBuilder` with advanced delimiter and formatting options.

- **Directory Composition**: Generate entire directory structures programmatically using `Directory`, `Folder`, and `File`. Build and compose your own `TextFile` and `DataFile` types,and compose them into complex, nested directory structures using `@DirectoryContentBuilder`

- **Data Composition**: Work with raw data using `DataComponent` and `DataBuilder`, allowing you to compose binary data structures in a declarative way.

Calligraphy's type-safe API and builder patterns make it ideal for code generation, configuration file creation, and any scenario where you need to programmatically generate text or file structures.

## Quick Start

These articles will help you setup Calligraphy in a new or exising project and detail the library's core concepts.

@Links(visualStyle: detailedGrid) {
    - <doc:Setup>
    - <doc:ComposingStrings>
    - <doc:ComposingDirectories>
}

## Topics

### String Composition

- ``StringComponent``
- ``StringBuilder``
- ``Delimited``
- ``Frozen``
- ``Joined``
- ``Line``
- ``Lines``
- ``Quote``
- ``Tabbed``
- ``MapLinesRule``
- ``StringComponents``
- ``DoubleQuote``
- ``QuotationMark``
- ``NewLine``
- ``RawStringComponent``
- ``SingleQuote``
- ``Space``
- ``Tab``
- ``TripleQuote``
- ``AnyStringComponent``

### Directory Composition

- ``DirectoryContent``
- ``DirectoryContentBuilder``
- ``Directory``
- ``TextFile``
- ``DataFile``
- ``FilePermissions``
- ``File``
- ``Folder``
- ``Files``
- ``EmptyDirectoryContent``
- ``AnyDirectoryContent``
- ``SerializedDirectoryContent``

### Data Composition

- ``DataComponent``
- ``DataBuilder``
- ``DataComponents``
- ``RawDataComponent``
- ``EmptyDataComponent``
- ``AnyDataComponent``
