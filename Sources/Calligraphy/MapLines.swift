// Calligraphy
// MapLines.swift
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

import Foundation

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke {

    /// Map every line of a multi-line stroke
    /// - Parameter fn: The function used to map each line into another string.
    /// If the provdided function returns `nil`, the line will be omitted
    /// - Returns: The line mapped stoke
    func mapLines(
        fn: @Sendable @escaping (String) -> String?
    ) -> some Stroke {
        MapLines(
            self,
            fn
        )
    }

    /// Map every line of a multi-line stroke, declaratively
    /// - Parameter calligraphy: The function used to map each line into another string.
    /// If the provdided function returns `nil`, the line will be omitted
    /// - Returns: The line mapped stoke
    func mapLines(
        @Calligraphy with calligraphy: @Sendable @escaping (String) -> some Stroke
    ) -> some Stroke {
        mapLines(fn: { line in
            String(stroke: calligraphy(line))
        })
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
struct MapLines<Strokes>: Stroke where Strokes: Stroke {

    init(
        _ strokes: Strokes,
        _ fn: @Sendable @escaping (String) -> String?
    ) {
        self.strokes = strokes
        self.fn = fn
    }

    var body: some Stroke {
        strokes
            .map { content in
                content?
                    .components(separatedBy: "\n")
                    .compactMap(fn)
                    .joined(separator: "\n")
            }
    }

    private let strokes: Strokes
    private let fn: @Sendable (String) -> String?
}
