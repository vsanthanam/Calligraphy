# Composing Strings

Use's Calligraphy's declarative API to compose complex, multi-line strings in Swift.

## Overview

The Calligraphy library introduces a domain-specific language (DSL) for string composition that makes it easy to create rich, reusable, and complex string content. At its core, this DSL is built around two key concepts:

1. The `StringComponent` protocol, which represents individual pieces of string content
2. The `StringBuilder` result builder, which provides a declarative syntax for composing multiple components

## Making String Components

A `StringComponent` is the basic building block of the Calligraphy DSL. Each string component represents either a concrete string value or a composition of one or more child components. You can implement `StringComponent` conformance in two ways:

1. **Imperatively** by implementing the `content` property to return a concrete string value
2. **Declaratively** by implementing the `body` property to compose child components

For example, here's a simple string component that returns a hard-coded string:

```swift
struct Greeting: StringComponent {
    
    let content: String?  = "Hello, World!"
    
}
```

And here's a more complex component that composes multiple child components:

```swift
struct WelcomeMessage: StringComponent {

    var body: some StringComponent {
        Lines {
            "Welcome to Calligraphy!"
            "This is a multi-line message."
            "Each line is a separate component."
        }
    }

}
```

## Combining String Components

The `StringBuilder` result builder provides a declarative syntax for composing multiple string components. It supports all the standard control flow statements you'd expect: if-else, optional binding, and switch statements, for loops.

Here's an example that demonstrates these features:

```swift
@StringBuilder
func generateMessage(for user: User?) -> some StringComponent {
    if let user = user {
        "Hello, \(user.name)!"
        if user.isNew {
            "Welcome to our platform!"
        }
    } else {
        "Hello, Guest!"
    }
    
    for feature in availableFeatures {
        "• \(feature.name)"
    }
}
```

### Separators

Unless explicitly specified otherwise, the `StringBuilder` uses a newline character (`\n`) as the separator between components.

You can change this behavior in several ways:

#### The Line and Lines components

You can wrap components using the `Line` component, which which will join its children together without a new line:

```swift
Line {
    "foo"
    "bar"
    "baz"
}
// result: "foobarbaz"
```

#### The joined modifier

#### The + operator

### More Stuff


## Best Practices

When using Calligraphy for string composition, consider these best practices:

1. **Break down complex strings** into smaller, reusable components
2. **Use the declarative approach** with `body` when composing multiple components
3. **Leverage the result builder** for complex conditional logic and loops
4. **Consider performance** when working with large strings by using `Frozen` to cache results
5. **Use type-erasure** with `AnyStringComponent` when you need to store components of different types
