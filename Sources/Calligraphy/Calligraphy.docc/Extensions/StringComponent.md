# ``Calligraphy/StringComponent``

@Metadata {
    @DocumentationExtension(mergeBehavior: override)
}

A component of a declaratively composed string

## Overview

A `StringComponent` is the basic building block of a ``StringBuilder`` DSL. Each string component represents either a hard coded string, or one or more child string components. You can implement`StringComponent` conformance either declaratively or imperatively. 

- To declaratively implement a string component that represents a composition of one or more child components, implement the ``body`` property.

- To imperatively implement a string component that represents a Swift string, implement the ``content`` property.

- Important: If you implement both the `content` property *and* the `body` property, the `content` property will be respected over the `body` property.

## Topics

### Associated Types

- ``Body``

### Instance Properties

- ``body``
- ``content``

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
