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
extension StringComponent {

    public func quoted(
        _ markType: QuotationMark.`Type` = .double
    ) -> some StringComponent {
        Quote(markType) { self }
    }

}

/// A string component that adds quotation marks to either side of its wrapped children.
///
/// Use this type to wrap a group of child components with quotation marks:
///
/// ```swift
/// let component = Quote(.single) {
///     "The quick brown fox jumps over the lazy dog"
/// }
/// ```
///
/// The above example would yield the following string:
///
/// ```
/// 'The quick brown fox jumps over the lazy dog'
/// ```
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Quote<T>: StringComponent where T: StringComponent {

    // MARK: - Initializers

    /// Created a quoted string component
    /// - Parameters:
    ///   - markType: The type of quotation mark to use
    ///   - components: The components to quote
    public init(
        _ markType: QuotationMark.`Type` = .double,
        @StringBuilder components: () -> T
    ) {
        self.markType = markType
        self.components = components()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        components
            .delimited {
                QuotationMark(markType)
            }
    }

    // MARK: - Private

    private let components: T
    private let markType: QuotationMark.`Type`

}
