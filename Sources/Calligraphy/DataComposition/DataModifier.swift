// Calligraphy
// DataModifier.swift
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

import Foundation

/// A modifier that you apply to a data component, producing a different version of the original component.
///
/// Adopt `DataModifier` to package a reusable transformation, the same way you adopt ``StringModifier`` for strings.
/// Implement ``body(content:)`` to describe the result, using `content` as a placeholder for whichever component the modifier is eventually applied to:
///
/// @Snippet(path: "Calligraphy/Snippets/DataModifier/CustomDataModifier", slice: "modifier")
///
/// Apply a modifier with ``DataComponent/modifier(_:)``. To make a modifier read like the built-in ones, wrap that call in an extension on ``DataComponent``:
///
/// @Snippet(path: "Calligraphy/Snippets/DataModifier/CustomDataModifier", slice: "extension")
///
/// A modifier can read the surrounding environment with the ``Environment`` property wrapper, just like a component can.
///
/// Most modifiers only need ``body(content:)``. A modifier that must work with the rendered bytes themselves, or change the environment the content renders in, can instead implement ``render(content:in:)`` and declare `Never` as its ``Body``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DataModifier {

    /// The type of data component produced by this modifier.
    ///
    /// Typically, you do not need to explicitly spell out this type. Instead, implement ``body(content:)`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
    associatedtype Body: DataComponent

    /// The type of the component passed to ``body(content:)``.
    ///
    /// This type is a placeholder for the component the modifier is applied to. You never create a value of this type yourself; one is supplied each time the modifier is applied.
    typealias Content = _DataModifier_Content<Self>

    /// Describe the component produced by applying this modifier.
    ///
    /// - Parameter content: A placeholder for the component the modifier is applied to.
    /// - Returns: The modified component.
    @DataBuilder
    func body(content: Self.Content) -> Body

    /// Render the modified content into `Data` using the supplied environment.
    ///
    /// The default implementation renders ``body(content:)``. Implement this method directly, and declare `Never` as the ``Body``, when the modifier needs the rendered bytes of its content or must render the content in a different environment. Any ``Environment`` properties on the modifier are resolved before this method is called.
    ///
    /// - Parameters:
    ///   - content: A placeholder for the component the modifier is applied to.
    ///   - environment: The environment values to read during rendering.
    /// - Returns: The rendered data, or `nil` if the modified component contributes nothing.
    func render(
        content: Self.Content,
        in environment: borrowing EnvironmentValues
    ) -> Data?

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataModifier {

    public func render(
        content: Self.Content,
        in environment: borrowing EnvironmentValues
    ) -> Data? {
        body(content: content)
            ._render(in: environment)
    }

    func fatalErrorImperativeDataModifier(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError(
            """
            DataModifier \(Self.self) does not have a body. Do not invoke this method directly.
            """,
            file: file,
            line: line
        )
    }

}

/// A placeholder for the component a ``DataModifier`` is applied to.
///
/// You never create this type directly. ``ModifiedData`` creates it and passes it to ``DataModifier/body(content:)``, where you refer to it as ``DataModifier/Content`` and compose around it as you would any other component. When rendered, the placeholder renders the original component in whatever environment the modifier's body provides.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct _DataModifier_Content<Modifier>: DataComponent where Modifier: DataModifier {

    // MARK: - Initializers

    init<Component>(
        erasing component: Component
    ) where Component: DataComponent {
        self.component = AnyDataComponent(erasing: component)
    }

    // MARK: - DataComponent

    public var body: Never {
        fatalErrorImperativeDataComponent()
    }

    public func _render(
        in environment: borrowing EnvironmentValues
    ) -> Data? {
        component._render(in: environment)
    }

    // MARK: - Private

    private let component: AnyDataComponent

}
