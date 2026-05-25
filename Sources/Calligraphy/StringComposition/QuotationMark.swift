// Calligraphy
// QuotationMark.swift
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

/// A string component that renders a quotation mark.
///
/// The character (or characters) rendered are controlled by the surrounding ``QuotationMarkStyle`` environment value. By default, a `QuotationMark` renders as a single double-quote character (`"`). To use a different style, apply the ``StringComponent/quotationMarkStyle(_:)`` modifier to an ancestor component, or pass an explicit style to the initializer to bypass the environment.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct QuotationMark: StringComponent {

    // MARK: - Initializers

    /// Create a quotation mark component.
    /// - Parameter style: An optional ``QuotationMarkStyle`` override. When `nil` (the default), the style is read from the surrounding ``StringEnvironmentValues/quotationMarkStyle`` environment value.
    public init(_ style: QuotationMarkStyle? = nil) {
        self.style = style
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        if let style {
            style
        } else {
            quotationMarkStyle
        }
    }

    // MARK: - Private

    private let style: QuotationMarkStyle?

    @StringEnvironment(\.quotationMarkStyle)
    private var quotationMarkStyle

}
