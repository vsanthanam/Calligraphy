// Calligraphy
// Delimited.swift
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

public extension Stroke {

    func delimited(by delimiter: String) -> some Stroke {
        Delimited(
            by: delimiter
        ) { self }
    }

    func delimited(
        @Calligraphy with delimiter: () -> some Stroke
    ) -> some Stroke {
        Delimited(
            content: { self },
            delimiter: delimiter
        )
    }

}

public struct Delimited<Delimiter, Content>: Stroke where Delimiter: Stroke, Content: Stroke {

    public init(
        by delimiter: String,
        @Calligraphy content: () -> Content
    ) where Delimiter == StringStroke {
        self.init(content: content) { delimiter }
    }

    public init(
        @Calligraphy content: () -> Content,
        @Calligraphy delimiter: () -> Delimiter
    ) {
        self.content = content()
        self.delimiter = delimiter()
    }

    public var body: some Stroke {
        Line {
            delimiter
            content
                .zipped()
            delimiter
        }
    }

    private let delimiter: Delimiter
    private let content: Content

}
