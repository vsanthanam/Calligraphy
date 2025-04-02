// Calligraphy
// Quoted.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke {

    /// Add quotation marks to either side of the upstream
    /// - Parameter delimiter: The type of quotation marks to apply to the upstream
    /// - Returns: A quoted version of the upstream
    func quoted(
        _ delimiter: QuotationMark.MarkType = .double
    ) -> some Stroke {
        Quoted(delimiter) { self }
    }

}

/// A stroke with quotation marks on either side of its children
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Quoted<T>: Stroke where T: Stroke {

    // MARK: - Initializers

    /// Create a quoted stroke
    /// - Parameters:
    ///   - delimiter: The type of quotation mark to apply to each side
    ///   - content: The content to quote
    public init(
        _ delimiter: QuotationMark.MarkType = .double,
        @Calligraphy content: () -> T
    ) {
        self.delimiter = delimiter
        self.content = content()
    }

    // MARK: - Stroke

    public var body: some Stroke {
        Delimited {
            content
        } delimiter: {
            delimiter
        }
    }

    // MARK: - Private

    private let content: T
    private let delimiter: QuotationMark.MarkType

}
