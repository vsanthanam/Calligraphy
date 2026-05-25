// Calligraphy
// Quote.swift
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

    /// Wrap this component in a pair of quotation marks.
    ///
    /// - Parameter style: An optional ``QuotationMarkStyle`` override. When `nil`, the style provided by the surrounding environment is used.
    /// - Returns: A component that renders as the receiver, wrapped in quotation marks.
    @StringBuilder
    public func quoted(
        _ style: QuotationMarkStyle? = nil
    ) -> some StringComponent {
        Quote(style) { self }
    }

}

extension StringEnvironmentValues {

    /// A flag indicating whether the current component is being rendered inside a ``Quote``.
    ///
    /// ``Quote`` sets this value to `true` on its wrapped content before rendering, allowing a descendant component to branch on whether it is being quoted — for example, to escape a nested quotation mark or to omit one entirely.
    ///
    /// ```swift
    /// struct Greeting: StringComponent {
    ///
    ///     @StringEnvironment(\.isInQuote)
    ///     private var isInQuote: Bool
    ///
    ///     var body: some StringComponent {
    ///         if isInQuote {
    ///             "hello"
    ///         } else {
    ///             "Hello!"
    ///         }
    ///     }
    ///
    /// }
    /// ```
    ///
    /// The value is read-only from outside this module — its lifecycle is managed by ``Quote``. Defaults to `false`.
    @StringEntry
    public internal(set) var isInQuote: Bool = false

}

/// A string component that wraps content between two `QuotationMark` components.
///
/// The style of the surrounding quotation marks is read from the current ``QuotationMarkStyle`` environment value, which can be overridden using ``StringComponent/quotationMarkStyle(_:)`` or by passing an explicit style to the initializer.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Quote<Quote>: StringComponent where Quote: StringComponent {

    /// Create a quoted component.
    /// - Parameters:
    ///   - style: An optional ``QuotationMarkStyle`` override. When `nil` (the default), the style is read from the surrounding environment. When supplied, the style is also propagated into `quote` so nested ``QuotationMark`` and ``Quote`` components inherit it.
    ///   - quote: The content to wrap in quotation marks.
    public init(
        _ style: QuotationMarkStyle? = nil,
        @StringBuilder quote: () -> Quote
    ) {
        self.style = style
        self.quote = quote()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        if let style {
            content
                .quotationMarkStyle(style)
        } else {
            content
        }
    }

    // MARK: - Private

    private let style: QuotationMarkStyle?
    private let quote: Quote

    private var content: some StringComponent {
        Line {
            QuotationMark()
            quote.environment(
                \.isInQuote,
                true
            )
            QuotationMark()
        }
    }

}
