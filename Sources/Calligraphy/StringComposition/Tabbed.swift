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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Add a tab to every line in the upstream
    /// - Parameter numberOfTabs: The number of tabs to add
    /// - Returns: A tabbed version of the upstream
    public func tabbed(
        _ numberOfTabs: Int = 1
    ) -> some StringComponent {
        Tabbed(numberOfTabs) { self }
    }

}

/// A string compoments with tabs on every line
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Tabbed<T>: StringComponent where T: StringComponent {

    // MARK: - Initializers

    /// Create a tabbed string component
    /// - Parameters:
    ///   - numberOfTabs: The number of tabs to each line
    ///   - components: The components to tab
    public init(
        _ numberOfTabs: Int = 1,
        @StringBuilder components: () -> T
    ) {
        assert(numberOfTabs >= 0, "Number of tabs must be non-negative")
        self.numberOfTabs = numberOfTabs >= 0 ? numberOfTabs : 1
        self.components = components()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        components
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
    private let components: T

}
