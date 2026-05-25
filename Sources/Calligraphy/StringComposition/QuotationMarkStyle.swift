// Calligraphy
// QuotationMarkStyle.swift
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

/// The style of a quotation mark.
///
/// This value controls the character (or characters) rendered by ``QuotationMark`` and ``Quote``. Use ``StringComponent/quotationMarkStyle(_:)`` to apply a style to a component and its descendants.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum QuotationMarkStyle: String, Sendable {

    /// A single straight-quote character (`'`).
    case single = "'"

    /// A single double-quote character (`"`).
    case double = "\""

    /// Three single straight-quote characters (`'''`).
    case tripleSingle = "'''"

    /// Three double-quote characters (`"""`).
    case tripleDouble = "\"\"\""

    /// The default quotation mark style (``QuotationMarkStyle/double``).
    public static let `default`: QuotationMarkStyle = .double

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringEnvironmentValues {

    /// The style of quotation mark used by ``QuotationMark`` and ``Quote``.
    ///
    /// Defaults to ``QuotationMarkStyle/default``. Set it on an ancestor component using ``StringComponent/quotationMarkStyle(_:)``.
    @StringEntry
    public internal(set) var quotationMarkStyle: QuotationMarkStyle = .default

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Apply a ``QuotationMarkStyle`` to this component.
    ///
    /// The supplied style becomes the ``StringEnvironmentValues/quotationMarkStyle`` for this component and its descendants. ``QuotationMark`` and ``Quote`` read this value when rendering.
    ///
    /// - Parameter style: The style of quotation mark to use.
    /// - Returns: A component whose descendants render quotation marks with the supplied style.
    public func quotationMarkStyle(
        _ style: QuotationMarkStyle
    ) -> some StringComponent {
        QuotationMarkStyleModifier(
            wrapped: self,
            style: style
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct QuotationMarkStyleModifier<T>: StringComponent where T: StringComponent {

    let wrapped: T

    let style: QuotationMarkStyle

    var body: some StringComponent {
        wrapped
            .environment(
                \.quotationMarkStyle,
                style
            )
    }

}
