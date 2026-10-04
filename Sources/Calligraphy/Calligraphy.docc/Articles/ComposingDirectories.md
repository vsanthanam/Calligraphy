# Composing Directories

@Metadata {
    @PageImage(purpose: card, source: "composing-directories.png", alt: "Declarative file with folder illustration")
    @PageKind(article)
}

Use `@DirectoryContentBuilder` to compose complex, nested directory structures and write them to disk.

## Overview

Calligraphy provides a powerful and type-safe API for composing directories and their contents. The library offers both built-in types for common use cases and the ability to create custom directory content types.

### Files

The ``File`` type allows you to create both text and data files:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/TextAndDataFiles", slice: "files")

### Folders

The ``Folder`` type enables you to create nested directory structures:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/NestedFolders", slice: "folders")

### Custom Directory Content Types

You can create reusable file and folder types that represent higher level concepts, such as a particular kind of file template or an asset bundle. To do this, you can create types that conform to the `TextFile`, `DataFile`, or `Directory` protocols.

#### Custom Text Files

For text files, conform to the ``TextFile`` protocol:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/CustomDirectoryContent", slice: "text-file")

#### Custom Data Files

For binary data files, conform to the ``DataFile`` protocol:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/CustomDirectoryContent", slice: "data-file")

#### Custom Directories

You can create custom directory types by conforming to the ``Directory`` protocol:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/CustomDirectoryContent", slice: "directory")

### Combining with @StringBuilder and @DataBuilder

The directory composition API works seamlessly with other Calligraphy builders:

- `@StringBuilder` for text content
- `@DataBuilder` for binary data
- `@DirectoryContentBuilder` for directory structure

This allows you to compose complex directory structures with rich content:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/CustomDirectoryContent", slice: "combining-builders")

### Repeating Content

``ForEach`` works in every builder. Use it to produce a file or folder for each element of a collection:

@Snippet(path: "Calligraphy/Snippets/ForEach/RepeatingFiles", slice: "files")

### Setting Environment Values on Folders

Files and folders are rendered lazily, when the tree is serialized or written, and the same environment flows through folders, files, and the components inside them. A value set on a folder with ``DirectoryContent/environment(_:_:)-(_,Value)``, or with a convenience such as ``DirectoryContent/lineSpacing(_:)``, is visible to every file beneath it:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/FolderEnvironment", slice: "folder-environment")

See <doc:UsingTheEnvironment> for details.

### Writing to Disk

All directory content types can be written to disk using the ``DirectoryContent/write(to:shouldOverwrite:)`` method:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/CustomDirectoryContent", slice: "writing-to-disk")

#### Platform Considerations

Before anything is written, the names of sibling files and folders are validated. Names are compared case-insensitively, so a tree containing both `README.md` and `readme.md` is rejected on every platform. Case-insensitive file systems such as APFS would otherwise treat the two as the same file, and the result would depend on which one happened to be written last.

Text files are encoded using the `encoding` supplied to ``File`` or ``TextFile``. Unicode encodings such as `.utf8` and `.utf16` are supported everywhere. Legacy encodings such as `.macOSRoman` or `.shiftJIS` depend on platform support and may cause the write to fail on Linux.
