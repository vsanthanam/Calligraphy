# Composing Strings

@Metadata {
    @PageImage(purpose: card, source: "composing-strings.png", alt: "Code book with fountain pen")
    @PageKind(article)
}

Use `@StringBuilder` to compose complex, multi-line strings in Swift.

## Overview

The Calligraphy library introduces a domain-specific language (DSL) for string composition that makes it easy to create rich, reusable, and complex string content. At its core, this DSL is built around two key concepts:

1. The ``StringComponent`` protocol, which represents individual pieces of string content
2. The ``StringBuilder`` result builder, which provides declarative syntax for composing multiple components into larger ones.

The DSL supports `StringComponent` conforming types, as well as regular Swift strings, for example:


@Snippet(path: "Calligraphy/Snippets/ComposingStrings/DeclarativeString", slice: "string-build")

## Making String Components

A ``StringComponent`` is the basic building block of the Calligraphy DSL. Each string component represents either a concrete string value or a composition of one or more child components or strings. Create a `StringComponent` by implementing the ``StringComponent/body`` property:

For example, here's a simple string component that returns a hard-coded string:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/MakingStringComponents", slice: "greeting")

And here's a more complex component that composes multiple child components:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/MakingStringComponents", slice: "welcome-message")

## Combining String Components

The ``StringBuilder`` result builder provides a declarative syntax for composing multiple string components. It supports all the standard control flow statements you'd expect: if-else, optional binding, switch statements, and for loops.

Here's an example that demonstrates some of these features:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/BuilderControlFlow", slice: "generate-message")

Use ``ForEach`` to repeat content for every element of a collection. A `for`-`in` loop is also accepted inside a builder, but it is deprecated in favor of ``ForEach``, which additionally allows modifiers inside the repeated content.

You can use the @StringBuilder result builder in several different ways:

- By applying the `@StringBuilder` attribute to any Swift function
- When defining your own `StringComponent`, by implementing the `body` property
- Using the ``StringGroup`` struct, which provides you with an entry point to the DSL and typed value you can store, pass around, modify, and compose into in other string builders.
- Using the ``Swift/String/build(_:)`` type method, which accepts a `@StringBuilder` closure as an argument.

### Component Separators

Unless explicitly specified by an upstream parent, `@StringBuilder` uses a newline character (`\n`) as the separator when assembling its children into a larger, parent component. You can change this behavior in several ways:

#### The Line component

You can wrap components using the ``Line`` component, which which will join its children together without a new line:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/ComponentSeparators", slice: "line")

This example would yield the following string:

```
foobarbaz
```

#### The Lines component

You can also use the ``Lines`` component, which joins its children with newlines. Combine it with the ``StringComponent/lineSpacing(_:)`` modifier to put more than one newline between them:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/ComponentSeparators", slice: "lines")

This example would yield the following string:

```
foo

bar

baz
```

#### The joined modifier

You can also define your own separator, using other strings or components of your choosing, using the ``StringComponent/joined(separator:)`` modifier:

@Snippet(path: "Calligraphy/Snippets/ComposingStrings/ComponentSeparators", slice: "joined")

This example would yield the following string:

```
Apple, Banana, Pear
```

