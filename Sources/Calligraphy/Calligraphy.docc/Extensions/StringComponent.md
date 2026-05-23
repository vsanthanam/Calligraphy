# ``Calligraphy/StringComponent``

@Metadata {
    @DocumentationExtension(mergeBehavior: override)
}

A type that contributes to the construction of a string.

## Overview

A `StringComponent` is a declarative representation of a piece of text. By composing components together inside a ``StringBuilder``, you build up a final `String` value the same way you would build a view hierarchy in SwiftUI.

Typically, you will not implement ``render(in:)`` directly. Instead, implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.

```swift
struct Greeting: StringComponent {

    let name: String

    var body: some StringComponent {
        "Hello, " + name + "!"
    }

}
```

## Topics

### Associated Types

- ``Body``

### Instance Properties

- ``body``

### Modifiers

- ``joined(separator:)``
- ``lineSpacing(_:)``
- ``prefixLines(with:)-(()->StringComponent)``
- ``prefixLines(with:)-(StringProtocol)``
- ``tabbed(_:_:)``
- ``quoted(_:)``
- ``quotationMarkStyle(_:)``
- ``tabDefinition(_:)``
- ``environment(_:_:)-(Key.Type,_)``
- ``environment(_:_:)-(_,Value)``
- ``transformEnvironment(_:)``

### Operators

- ``+(_:_:)->Line<StringBuilder._Assembled<LHS,RHS>>``
- ``+(_:_:)->Line<StringBuilder._Assembled<RawStringComponent,RHS>>``
- ``+(_:_:)->Line<StringBuilder._Assembled<LHS,RawStringComponent>>``
