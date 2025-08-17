// Calligraphy
// QuotationMark.swift
//
// MIT License
//
// Copyright (c) 2025 Varun Santhanam
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

/// Create a quotation mark.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct QuotationMark: StringComponent {

    // MARK: - Initializers

    /// Create a quotation mark
    public init() {}

    // MARK: - API

    /// The available quotation mark styles.
    public enum Style: Sendable {

        /// Single quotation mark (`'`)
        case single

        /// Double quotation mark (`"`)
        case double

        /// Triple quotation mark (`'''`)
        case triple

        /// The default quotation mark style.
        public static let `default`: Style = .double
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        _Guts(StringEnvironment.activeQuotationMarkStyle)
    }

    // MARK: - Private

    private struct _Guts: StringComponent {

        init(_ style: QuotationMark.Style) {
            self.style = style
        }

        var body: some StringComponent {
            switch style {
            case .single:
                "'"
            case .double:
                "\""
            case .triple:
                "'''"
            }
        }

        private let style: QuotationMark.Style

    }
}
