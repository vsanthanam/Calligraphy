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

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public extension Stroke {

    func tabbed(
        _ count: Int = 1
    ) -> some Stroke {
        Tabbed(count) { self }
    }

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct Tabbed<T>: Stroke where T: Stroke {

    // MARK: - Initializers

    public init(
        _ count: Int,
        @Calligraphy strokes: () -> T
    ) {
        precondition(count >= 0, "Tab count must be non-negative.")
        self.count = count
        self.strokes = strokes()
    }

    // MARK: - Stroke

    public var body: some Stroke {
        let tabs = String(repeating: "    ", count: count)
        strokes
            .map { content in
                guard let content else { return nil }
                return content
                    .components(separatedBy: "\n")
                    .map { tabs + $0 }
                    .joined(separator: "\n")
            }
    }

    // MARK: - Private

    private let count: Int
    private let strokes: T

}
