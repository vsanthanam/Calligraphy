# Using the String Environment

@Metadata {
    @PageKind(article)
}

Read and write values that flow through a ``StringComponent`` tree.

## Overview

Every ``StringComponent`` is rendered with an instance of ``StringEnvironmentValues`` that flows from ancestor to descendant. This is the same pattern as SwiftUI's `EnvironmentValues`: a parent component can set a value, and any descendant can read it without the value being passed explicitly through initializers.

Calligraphy itself uses the environment to configure built-in components — for example, ``Lines`` reads ``StringEnvironmentValues/lineSpacing`` to decide how many newlines to put between its children, and ``QuotationMark`` reads ``StringEnvironmentValues/quotationMarkStyle`` to choose its character. The same machinery is available to your own components.

## Reading Values

Inside a `StringComponent`, use the ``StringEnvironment`` property wrapper to read a value from the surrounding environment. The wrapper resolves lazily at render time, so its value is always current — and because the property is read inside `body`, you can branch on it normally:

```swift
struct ListItem: StringComponent {

    @StringEnvironment(\.lineSpacing)
    private var spacing: Int

    let text: String

    var body: some StringComponent {
        if spacing > 1 {
            "• \(text)"
        } else {
            "- \(text)"
        }
    }

}
```

The property wrapper is populated by reflection on the enclosing `StringComponent`, so it only works as a stored property of a component. When you need to read the environment outside of that context — in a free `@StringBuilder` function, inside a `String.build { ... }` closure, or anywhere else — reach for ``ReadEnvironment`` instead:

```swift
let component = ReadEnvironment { environment in
    if environment.lineSpacing > 1 {
        "spaced"
    } else {
        "tight"
    }
}
```

## Writing Values

Use the ``StringComponent/environment(_:_:)-(_,Value)`` modifier to set an environment value on a component and its descendants. Ancestor components are unaffected.

```swift
let component = Lines {
    "foo"
    "bar"
    "baz"
}
.environment(\.lineSpacing, 2)
```

When you need to set multiple values at once, or compute the new value from the current one, use ``StringComponent/transformEnvironment(_:)``:

```swift
Lines {
    "foo"
    "bar"
}
.transformEnvironment { environment in
    environment.lineSpacing = 2
    environment.tabDefinition = .spaces(4)
}
```

If two modifiers in the same chain write the same value, the one closest to the descendants wins, because it transforms the environment last.

## Defining Custom Environment Values

To expose your own environment value, extend ``StringEnvironmentValues`` and annotate a stored property with the ``StringEntry()`` macro. The macro synthesizes a private ``StringEnvironmentKey`` and the getter/setter accessors that read from and write to the environment storage.

```swift
extension StringEnvironmentValues {

    @StringEntry
    public var prefix: String = "•"

}
```

The property's initial value becomes the default returned when no ancestor has set the value:

```swift
struct ListItem: StringComponent {

    @StringEnvironment(\.prefix)
    private var prefix: String

    let text: String

    var body: some StringComponent {
        "\(prefix) \(text)"
    }

}
```

Optional types do not need an initial value — when omitted, the default is `nil`:

```swift
extension StringEnvironmentValues {

    @StringEntry
    public var caption: String?

}
```
