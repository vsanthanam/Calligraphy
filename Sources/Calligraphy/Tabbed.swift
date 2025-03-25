// Calligraphy
// Tabbed.swift
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

/// A stroke which applies a tab to each line of its children
///
/// You can use a tabbed stroke to add tabs as line prefixes to multline children, for example:
///
/// ```swift
/// let example = Lines {
///     "{"
///     Tabbed {
///         Strokes {
///             "apple"
///             "pear"
///             "banana"
///         }
///         .separatedBy {
///             Line {
///                 NewLine()
///                 ","
///             }
///         }
///     }
///     "}"
/// }
/// ```
///
/// This example would yield the following mult-iline string:
///
/// ```
/// {
///     apple,
///     pear,
///     banana
/// }
/// ```
@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct Tabbed<T>: Stroke where T: Stroke {

    // MARK: - Initializers

    /// Create a tabbed stroke
    /// - Parameters:
    ///   - numberOfTabs: The number of tabs to add to each line
    ///   - strokes: The strokes to add tabs to
    /// - Warning: You must provide a positive value to `numberOfTabs`. If you provide a negetive value, a runtime failure will occur.
    public init(
        _ numberOfTabs: Int = 1,
        @Calligraphy strokes: () -> T
    ) {
        precondition(numberOfTabs >= 0, "Tab count must be non-negative.")
        self.numberOfTabs = numberOfTabs
        self.strokes = strokes()
    }

    // MARK: - Stroke

    public var body: some Stroke {
        strokes
            .prefixLines {
                Line {
                    for _ in 0 ..< numberOfTabs {
                        Tab()
                    }
                }
            }
    }

    // MARK: - Private

    private let numberOfTabs: Int
    private let strokes: T

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public extension Stroke {

    /// Add a tab to each line of the upstream
    /// - Parameter count: The number of tabs to add
    /// - Returns: The tabbed stroke
    func tabbed(
        _ count: Int = 1
    ) -> some Stroke {
        Tabbed(count) { self }
    }

}
