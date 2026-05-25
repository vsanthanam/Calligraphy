// Calligraphy
// ArrayExtensions.swift
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
extension Array {

    /// Transform each element of this array into a ``StringComponent`` and combine the results.
    ///
    /// Use this overload to embed an array directly into a `@StringBuilder` block. Because the closure is itself a `@StringBuilder`, the full DSL — including conditionals and nested control flow — is available when shaping each element's contribution.
    ///
    /// ```swift
    /// let items = ["apple", "banana", "cherry"]
    ///
    /// let list = String.build {
    ///     items.map { item in
    ///         "- \(item)"
    ///     }
    /// }
    /// // - apple
    /// // - banana
    /// // - cherry
    /// ```
    ///
    /// - Parameter mapper: A `@StringBuilder` closure that transforms each element into a ``StringComponent``.
    /// - Returns: A component that renders `mapper` applied to each element in order.
    /// - Note: This overload is `@_disfavoredOverload`, so it participates in overload resolution only when the closure is constrained into returning a ``StringComponent``.
    @StringBuilder
    @_disfavoredOverload
    public func map(
        @StringBuilder mapper: (Element) -> some StringComponent
    ) -> some StringComponent {
        for value in self {
            mapper(value)
        }
    }

}
