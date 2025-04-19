# ``Calligraphy/StringComponent``

@Metadata {
    @DocumentationExtension(mergeBehavior: override)
}

A component of a declaratively composed string

## Overview

A `StringComponent` is the basic building block of a ``StringBuilder`` DSL. Each string component represents one or more child string components or Swift strings.

To create a String component, implement the ``body`` property and use the result builder to declare the child strings or components

```swift
struct Greeting: StringComponent {

    let name: String

    var body: some StringComponent {
        "Hello"
        name
        "Welcome to Calligraphy!"
    }

}
```

## Topics

### Associated Types

- ``Body``

### Instance Properties

- ``body``

### Modifiers

- ``delimited(by:)``
- ``delimited(with:)``
- ``frozen()``
- ``joined(separator:)``
- ``joined(by:)``
- ``map(_:)``
- ``map(with:)``
- ``mapLines(_:_:)``
- ``mapLines(_:with:)``
- ``prefixLines(with:_:)``
- ``prefixLines(_:components:)``
- ``quoted(_:)``
- ``suffixLines(with:_:)``
- ``suffixLines(_:components:)``
- ``tabbed(_:)``
