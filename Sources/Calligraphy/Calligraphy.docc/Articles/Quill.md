# Quill

@Metadata {
    @PageImage(purpose: card, source: "quill-sample.png", alt: "A quill standing in a glass inkwell on a brushed aluminium base engraved with a pair of braces.")
    @PageKind(sampleCode)
    @CallToAction(file: "Quill-Finished.zip", purpose: download)
}

Generate a Swift package from a description of a web service.

## Overview

Quill is the command-line tool built step by step in the <doc:Building-Quill> tutorials. It reads a service description written in [Manuscript](https://github.com/vsanthanam/Manuscript), a small JSON format, and writes a complete Swift package: a model type for every type in the service, an API client with a method for every endpoint, a package manifest, a README, and a script that regenerates the package.

This page holds the finished project. Download it to read the complete source, or follow the tutorials to build it yourself. Each tutorial after the first also offers the project as it stands at that point, so you can start anywhere. The same source is checked in at [Samples/Quill](https://github.com/vsanthanam/Calligraphy/tree/main/Samples/Quill) in the Calligraphy repository, and it is regenerated from the tutorial listings whenever they change.

### Running the generator

Quill requires Xcode 27 or Swift 6.4. Unzip the download, then from inside the `Quill` directory run the generator against the included `petstore.json`:

```sh
swift run Quill petstore.json --output ./out --access-level public --indent 4 --copyright "Acme"
```

The generated package lands in `out/Petstore` and builds on its own:

```sh
cd out/Petstore && swift build
```

| Option | Effect |
| --- | --- |
| `--output <directory>` | Where to write the package. Defaults to the current directory. |
| `--access-level internal\|public` | The access level of every generated declaration. |
| `--indent <count\|tab>` | The indentation of the generated Swift. |
| `--copyright <holder>` | Adds a copyright block to the top of every Swift file. |
| `--force` | Replace a package that already exists at the destination. |

### What the source demonstrates

Every core concept of the library appears somewhere in the project:

- **Result builder control flow** in `EndpointMethod.swift` and `TypeDeclaration.swift`, where `if`, `if let`, `switch`, and ``ForEach`` shape the output.
- **Composition** in `StructDeclaration.swift`, `Property.swift`, and `ClientDeclaration.swift`, which nest ``Line``, ``Lines``, and ``Group`` and apply modifiers such as ``StringComponent/tabbed(_:)``, ``StringComponent/joined(separator:)``, and ``StringComponent/lineSpacing(_:)``.
- **Directory composition** in `GeneratedPackage.swift` and `ClientFile.swift`, which describe the package as a ``Directory`` of ``Folder`` and ``File`` content, including an executable script with ``FilePermissions``.
- **The environment** in `Environment.swift`, `AccessModifier.swift`, `GeneratedNotice.swift`, and `LicenseHeader.swift`, which add custom values with ``Entry()``, read them with ``Environment`` and a custom ``DynamicProperty``, locate the file being written with ``FilePath``, and wrap output with a ``StringModifier``.
- **Configuration from the command line** in `Quill.swift` and `Indentation.swift`, where options become environment values and formatting modifiers on the generated directory.
- **Testing** in `StructDeclarationTests.swift`, which renders components to strings with Swift Testing, with and without environment values applied.
