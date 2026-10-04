// Calligraphy
// ForEach.swift
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

/// A string component that produces content for every element of a collection.
///
/// Use `ForEach` to repeat a piece of a string for each element in a collection, the way you would use `ForEach` in SwiftUI. The `content` closure is a `@StringBuilder`, so the full DSL is available when describing each element's contribution, including conditionals and modifiers:
///
/// @Snippet(path: "Calligraphy/Snippets/ForEach/RepeatingContent", slice: "for-each")
///
/// `ForEach` is transparent to layout, like ``StringGroup``: the results are joined using the surrounding ``EnvironmentValues/separator``, so inside ``Lines`` each element starts on a new line and inside ``Line`` the elements are concatenated. Elements whose content renders nothing are skipped.
///
/// Prefer `ForEach` to a `for`-`in` loop inside a builder. Loops are supported for compatibility, but they are deprecated and cannot contain expressions whose type is opaque, such as the result of a modifier.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct ForEach<Data, Content>: StringComponent where Data: Collection, Content: StringComponent {

    // MARK: - Initializers

    /// Create a component that produces content for every element of a collection.
    ///
    /// - Parameters:
    ///   - data: The collection to iterate over.
    ///   - content: A `@StringBuilder` closure that produces the content for a single element.
    public init(
        _ data: Data,
        @StringBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
    }

    // MARK: - StringComponent

    public var body: Never {
        fatalErrorImperativeStringComponent()
    }

    public func render(
        in environment: EnvironmentValues
    ) -> String? {
        let pieces = data
            .map { element in
                content(element).render(in: environment)
            }
        return environment.draw(with: pieces)
    }

    // MARK: - Private

    private let data: Data
    private let content: (Data.Element) -> Content

}
