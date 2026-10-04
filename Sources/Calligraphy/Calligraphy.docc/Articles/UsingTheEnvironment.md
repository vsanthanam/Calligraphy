# Using the Environment

@Metadata {
    @PageKind(article)
}

Read and write values that flow through string, data, and directory trees.

## Overview

Every ``StringComponent``, ``DataComponent``, and ``DirectoryContent`` is rendered with an instance of ``EnvironmentValues`` that flows from ancestor to descendant. This is the same pattern as SwiftUI's `EnvironmentValues`: a parent can set a value, and any descendant can read it without the value being passed explicitly through initializers.

The environment is shared across all three builders. A ``Directory`` passes its environment to the files inside it, and a file passes its environment to the components that render its contents. A value set on a ``Folder`` is therefore visible to every ``StringComponent`` or ``DataComponent`` in every file beneath it.

Calligraphy itself uses the environment to configure built-in components — for example, ``Lines`` reads ``EnvironmentValues/lineSpacing`` to decide how many newlines to put between its children, and ``QuotationMark`` reads ``EnvironmentValues/quotationMarkStyle`` to choose its character. The same machinery is available to your own components.

> Note: SwiftUI declares types named `Environment`, `EnvironmentValues`, `EnvironmentKey`, and `Entry`. In a file that imports both modules, qualify Calligraphy's with the module name, for example `@Calligraphy.Environment`.

## Reading Values

Inside a component, use the ``Environment`` property wrapper to read a value from the surrounding environment. The wrapper resolves lazily at render time, so its value is always current — and because the property is read inside `body`, you can branch on it normally:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingEnvironmentValues", slice: "property-wrapper")

The property wrapper works the same way in a ``DataComponent``, and in types that conform to ``TextFile``, ``DataFile``, or ``Directory``.

The property wrapper is populated by reflection on the enclosing type, so it only works as a stored property of a component. When you need an environment value somewhere else, such as a free `@StringBuilder` function or a `String.build { ... }` closure, move that piece of content into a small component type and read the value there, the same way you would introduce a `View` in SwiftUI.

## Reading the File Name

``File``, ``TextFile``, and ``DataFile`` set the name of the file, including its extension, before rendering their contents. Read it with the ``FileName`` property wrapper from any string or data component inside a file, and adapt the output to where it is being written:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingFileName", slice: "header")

The value is `nil` outside of any file, and on a file type itself, which already knows its own name.

## Writing Values

Use the ``StringComponent/environment(_:_:)-(_,Value)`` modifier to set an environment value on a component and its descendants. Ancestor components are unaffected. ``DataComponent`` and ``DirectoryContent`` have the same modifiers, so you can set a value once on a folder and have it reach every file inside:

@Snippet(path: "Calligraphy/Snippets/ComposingDirectories/FolderEnvironment", slice: "folder-environment")

The built-in values are read-only outside of Calligraphy, so each of them has a dedicated modifier: ``StringComponent/lineSpacing(_:)``, ``StringComponent/tabDefinition(_:)``, ``StringComponent/quotationMarkStyle(_:)``, and ``StringComponent/joined(separator:)``.

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "line-spacing")

Values you define yourself, such as the `prefix` entry in the next section, can be set with `environment(_:_:)` directly:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "environment")

When you need to set multiple values at once, or compute the new value from the current one, use ``StringComponent/transformEnvironment(_:)``:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "transform-environment")

If two modifiers in the same chain write the same value, the one closest to the descendants wins, because it transforms the environment last.

## Defining Custom Environment Values

To expose your own environment value, extend ``EnvironmentValues`` and annotate a stored property with the ``Entry()`` macro. The macro synthesizes a private ``EnvironmentKey`` and the getter/setter accessors that read from and write to the environment storage.

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "entry")

The property's initial value becomes the default returned when no ancestor has set the value:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "read-entry")

Optional types do not need an initial value — when omitted, the default is `nil`:

@Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentValues", slice: "optional-entry")

