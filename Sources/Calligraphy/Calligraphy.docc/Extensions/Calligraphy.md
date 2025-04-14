# ``Calligraphy``

A declarative API for composing multi-line strings, files, and folders in Swift

## Overview

Calligraphy provides a powerful and intuitive way to compose complex text structures in Swift. Whether you're building multi-line strings, generating code, or creating entire directory structures, Calligraphy offers a declarative API that makes your code more readable and maintainable.

The library is organized into three main areas:

- **String Composition**: Create and manipulate strings with components like `Line`, `Lines`, `Quoted`, and `Tabbed`. Build complex string structures using the `StringBuilder` and combine them with delimiters and formatting options.

- **Directory Composition**: Generate entire directory structures programmatically using `Directory`, `Folder`, and various file types like `TextFile` and `DataFile`. The `DirectoryContentBuilder` makes it easy to compose complex directory hierarchies.

- **Data Composition**: Work with raw data using `DataComponent` and `DataBuilder`, allowing you to compose binary data structures in a declarative way.

Calligraphy's type-safe API and builder patterns make it ideal for code generation, configuration file creation, and any scenario where you need to programmatically generate text or file structures.

## Start Here

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
- ``Quoted``
- ``Tabbed``
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
