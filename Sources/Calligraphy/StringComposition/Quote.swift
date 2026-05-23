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
        if let style {
            Quote { self }
                .quotationMarkStyle(style)
        } else {
            Quote { self }
        }
    }

}

/// A string component that wraps content between two ``QuotationMark`` characters.
///
/// The style of the surrounding quotation marks is read from the current ``QuotationMarkStyle`` environment value, which can be overridden using ``StringComponent/quotationMarkStyle(_:)``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Quote<Quote>: StringComponent where Quote: StringComponent {

    /// Create a quoted component.
    /// - Parameter quote: The content to wrap in quotation marks.
    public init(
        @StringBuilder quote: () -> Quote
    ) {
        self.quote = quote()
    }

    public var body: some StringComponent {
        QuotationMark() + quote + QuotationMark()
    }

    private let quote: Quote

}
