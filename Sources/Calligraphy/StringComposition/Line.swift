// Calligraphy
// Line.swift
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

/// A string component that joins its children together with no separator.
///
/// `Line` is the dual of ``Lines``: where `Lines` separates its children with newlines, `Line` concatenates them edge-to-edge. Use it to group inline pieces that should render on a single line, even when used inside a newline-separated context.
///
/// ```swift
/// Line {
///     "Hello, "
///     name
///     "!"
/// }
/// ```
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Line<Components>: StringComponent where Components: StringComponent {

    // MARK: - Initializers

    /// Create a line by composing components together edge-to-edge.
    /// - Parameter components: The components to combine, with no separator between them.
    public init(
        @StringBuilder components: () -> Components
    ) {
        self.components = components()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        components
            .joined(separator: "")
    }

    // MARK: - Private

    private let components: Components

}
