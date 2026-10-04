// Calligraphy
// LineSpacing.swift
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

    /// Set the number of newlines that ``Lines`` uses to separate adjacent children.
    ///
    /// Line spacing is an environment value, so it is inherited the way SwiftUI's environment-backed modifiers are: it applies to every ``Lines`` beneath this component, however deeply nested. Apply the modifier again to a nested ``Lines`` to give it a different spacing.
    ///
    /// @Snippet(path: "Calligraphy/Snippets/LineSpacing/NestedLineSpacing", slice: "nested")
    ///
    /// The example above renders `foo`, a blank line, and then `bar` and `baz` on adjacent lines. Without the inner modifier, `bar` and `baz` would also be separated by a blank line.
    ///
    /// - Parameter count: The number of newlines used to separate lines. Use `1` for normal single-spacing, `2` for one blank line between each pair of lines, and so on.
    /// - Returns: A component whose descendants render with the supplied line spacing.
    public func lineSpacing(
        _ count: Int
    ) -> some StringComponent {
        modifier(
            LineSpacingModifier(
                count: count
            )
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringEnvironmentValues {

    /// The number of newlines used to separate adjacent lines.
    ///
    /// Defaults to `1`. ``Lines`` reads this value to decide how to join its children. Like every environment value it is inherited by all descendants. Set it on an ancestor component using ``StringComponent/lineSpacing(_:)``.
    @StringEntry
    public internal(set) var lineSpacing: Int = 1

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct LineSpacingModifier: StringModifier {

    let count: Int

    func body(content: Content) -> some StringComponent {
        content
            .environment(
                \.lineSpacing,
                count
            )
    }

}
