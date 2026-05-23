// Calligraphy
// StringComponent.swift
//
// MIT License
//
// Copyright (c) 2026 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// A type that contributes to the construction of a string.
///
/// A `StringComponent` is a declarative representation of a piece of text. By composing components together inside a ``StringBuilder``, you build up a final `String` value the same way you would build a view hierarchy in SwiftUI.
///
/// Typically, you will not implement ``render(in:)`` directly. Instead, implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
///
/// ```swift
/// struct Greeting: StringComponent {
///
///     let name: String
///
///     var body: some StringComponent {
///         "Hello, " + name + "!"
///     }
///
/// }
/// ```
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@_typeEraser(AnyStringComponent)
public protocol StringComponent {

    /// The type of string component representing the body of this string component.
    ///
    /// Typically, you do not need to explicitly spell out this type.
    /// Instead, implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
    associatedtype Body: StringComponent

    /// The sub components used to build this string component.
    @StringBuilder
    var body: Body { get }

    /// Render this component into a `String` using the supplied environment.
    ///
    /// You rarely need to call this method directly. Instead, convert a component to a `String` using ``Swift/String/init(_:)``, which evaluates the component in a fresh environment.
    ///
    /// - Parameter environment: The environment values to read during rendering.
    /// - Returns: The rendered string, or `nil` if the component contributes nothing.
    func render(
        in environment: StringEnvironmentValues
    ) -> String?

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        for child in Mirror(reflecting: self).children {
            (child.value as? (any StringEnvironmentPropertyWrapper))?.inject(environment)
        }
        return body.render(in: environment)
    }

    func fatalErrorImperativeStringComponent(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError(
            """
            StringComponent \(Self.self) does not have a body. Do not invoke this property directly.
            """,
            file: file,
            line: line
        )
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: StringComponent {

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        fatalError()
    }

}

/// Concatenate two string components edge-to-edge on a single line.
///
/// The result is equivalent to wrapping both operands in a ``Line``.
///
/// - Parameters:
///   - lhs: The component to render first.
///   - rhs: The component to render second.
/// - Returns: A ``Line`` that renders `lhs` followed by `rhs` with no separator.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<LHS, RHS>> where LHS: StringComponent, RHS: StringComponent {
    Line {
        lhs
        rhs
    }
}

/// Concatenate a string and a string component edge-to-edge on a single line.
///
/// The string is converted to a ``RawStringComponent`` before joining.
///
/// - Parameters:
///   - lhs: The string to render first.
///   - rhs: The component to render second.
/// - Returns: A ``Line`` that renders `lhs` followed by `rhs` with no separator.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<RawStringComponent, RHS>> where LHS: StringProtocol, RHS: StringComponent {
    RawStringComponent(lhs) + rhs
}

/// Concatenate a string component and a string edge-to-edge on a single line.
///
/// The string is converted to a ``RawStringComponent`` before joining.
///
/// - Parameters:
///   - lhs: The component to render first.
///   - rhs: The string to render second.
/// - Returns: A ``Line`` that renders `lhs` followed by `rhs` with no separator.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<LHS, RawStringComponent>> where LHS: StringComponent, RHS: StringProtocol {
    lhs + RawStringComponent(rhs)
}
