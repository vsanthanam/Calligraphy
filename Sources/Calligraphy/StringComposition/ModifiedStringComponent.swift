// Calligraphy
// ModifiedStringComponent.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Apply a ``StringModifier`` to this component.
    ///
    /// Use this method to apply a custom modifier, or wrap it in an extension on ``StringComponent`` so the modifier reads like a built-in one:
    ///
    /// @Snippet(path: "Calligraphy/Snippets/StringModifier/CustomModifier", slice: "extension")
    ///
    /// - Parameter modifier: The modifier to apply.
    /// - Returns: This component with the modifier applied.
    public func modifier<Modifier>(
        _ modifier: Modifier
    ) -> ModifiedStringComponent<Self, Modifier> where Modifier: StringModifier {
        ModifiedStringComponent(
            content: self,
            modifier: modifier
        )
    }

}

/// A string component with a ``StringModifier`` applied to it.
///
/// You rarely create this type directly. It is the return type of ``StringComponent/modifier(_:)``, which pairs a component with a modifier. When the pair is rendered, the modifier's ``StringModifier/body(content:)`` is expanded with a placeholder standing in for `content`, and the result is rendered in the current environment. Any ``StringEnvironment`` properties declared by the modifier are resolved first, so a modifier can read the environment just like a component can.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct ModifiedStringComponent<Content, Modifier>: StringComponent where Content: StringComponent, Modifier: StringModifier {

    // MARK: - Initializers

    /// Create a string component with a modifier applied to it.
    ///
    /// Prefer ``StringComponent/modifier(_:)`` over calling this initializer directly.
    ///
    /// - Parameters:
    ///   - content: The component to modify.
    ///   - modifier: The modifier to apply.
    public init(
        content: Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }

    // MARK: - StringComponent

    public var body: Never {
        fatalErrorImperativeStringComponent()
    }

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        for child in Mirror(reflecting: modifier).children {
            (child.value as? (any StringEnvironmentPropertyWrapper))?.inject(environment)
        }
        return modifier
            .render(
                content: .init(erasing: content),
                in: environment
            )
    }

    // MARK: - Private

    private let content: Content
    private let modifier: Modifier

}
