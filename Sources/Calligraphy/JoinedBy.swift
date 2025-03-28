// Calligraphy
// SeparatedBy.swift
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

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public extension Stroke {

    func joinedBy(
        _ separator: String
    ) -> some Stroke {
        JoinedBy(separator) { self }
    }

    func joinedBy(
        @Calligraphy calligraphy: () -> some Stroke
    ) -> some Stroke {
        JoinedBy(
            strokes: { self },
            separator: calligraphy
        )
    }

}

/// Join the child strokes together into a single stroke using a provided separator
@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct JoinedBy<T>: Stroke where T: Stroke {

    // MARK: - Initializers

    /// Create a `JoinedBy` stroke with a `String` separator
    /// - Parameters:
    ///   - separator: The separator used to join the children
    ///   - strokes: The children to join
    public init(
        _ separator: String,
        @Calligraphy strokes: () -> T
    ) {
        self.separator = separator
        self.strokes = strokes()
    }

    /// Create a `JoinedBy` stroke using a ``Stroke`` separator
    /// - Parameters:
    ///   - strokes: The children to join
    ///   - separator: The separator used to join the children
    public init(
        @Calligraphy strokes: () -> T,
        @Calligraphy separator: () -> some Stroke
    ) {
        self.init(.init(calligraphy: separator), strokes: strokes)
    }

    // MARK: - Stroke

    public var content: String? {
        Calligraphy.$separator.withValue(separator) {
            strokes.content
        }
    }

    // MARK: - Private

    private let strokes: T
    private let separator: String

}
