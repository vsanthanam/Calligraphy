// Calligraphy
// PrefixLines.swift
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
    
    /// Add a prefix to every line of a multi-line stroke
    /// - Parameter prefix: The prefix to add
    /// - Returns: A line-prefixed version of the upstream
    func prefixLines(
        with prefix: String
    ) -> some Stroke {
        PrefixLines(
            self,
            prefix
        )
    }
    
    /// Add a prefix to every line of a multi-line stroke
    /// - Parameter calligraphy: The prefix to add
    /// - Returns: A line-prefixed version of the upstream
    func prefixLines(
        @Calligraphy with calligraphy: () -> some Stroke
    ) -> some Stroke {
        let prefix = String(calligraphy: calligraphy)
        return prefixLines(with: prefix)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
struct PrefixLines<Strokes>: Stroke where Strokes: Stroke {

    // MARK: - Initializers

    init(
        _ strokes: Strokes,
        _ prefix: String
    ) {
        self.strokes = strokes
        self.prefix = prefix
    }

    // MARK: - Stroke

    var body: some Stroke {
        strokes
            .mapLines { line in
                prefix + line
            }
    }

    // MARK: - Private

    private let strokes: Strokes
    private let prefix: String

}
