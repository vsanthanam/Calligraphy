// Calligraphy
// Lines.swift
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

/// A string component that joins its children together with newlines.
///
/// `Lines` is the standard way to assemble multi-line strings. Each child renders independently, and the children are joined by a newline.
/// Apply ``StringComponent/lineSpacing(_:)`` to put more than one newline between them.
///
/// Like every environment-backed modifier, line spacing is inherited: it applies to this `Lines` and to every `Lines` nested anywhere beneath it.
/// Apply ``StringComponent/lineSpacing(_:)`` to a nested `Lines` to give it a different spacing.
///
/// @Snippet(path: "Calligraphy/Snippets/Lines/JoiningLines", slice: "lines")
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Lines<Components>: StringComponent where Components: StringComponent {

    // MARK: - Initializers

    /// Create a block of lines.
    /// - Parameters:
    ///   - spacing: The number of newlines between each line. When `nil`, the value of the surrounding ``EnvironmentValues/lineSpacing`` environment value is used (typically `1`).
    ///   - components: The children to combine, one per line.
    @available(*, deprecated, message: "Use the lineSpacing(_:) modifier instead.")
    public init(
        spacing: Int?,
        @StringBuilder components: () -> Components
    ) {
        self.spacing = spacing
        self.components = components()
    }

    /// Create a block of lines.
    ///
    /// The number of newlines between each line is read from the surrounding ``EnvironmentValues/lineSpacing`` environment value (typically `1`). Use the ``StringComponent/lineSpacing(_:)`` modifier to change it. The value is inherited by nested `Lines`.
    ///
    /// - Parameter components: The children to combine, one per line.
    public init(
        @StringBuilder components: () -> Components
    ) {
        self.spacing = nil
        self.components = components()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        if let spacing {
            _Guts(lines: components)
                .lineSpacing(spacing)
        } else {
            _Guts(lines: components)
        }
    }

    // MARK: - Private

    private let components: Components
    private let spacing: Int?

    private struct _Guts<T>: StringComponent where T: StringComponent {

        let lines: T

        @Environment(\.effectiveSeparator)
        var effectiveSeparator

        var body: some StringComponent {
            lines
                .joined(separator: effectiveSeparator)
        }

    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension EnvironmentValues {

    fileprivate var effectiveSeparator: String {
        Array(repeating: "\n", count: lineSpacing).joined(separator: "")
    }

}
