// Calligraphy
// Quote.swift
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

    func quoted(
        _ quoteType: Quote<Self>.QuoteType = .double
    ) -> some Stroke {
        Quote(quoteType) { self }
    }

}

public struct Quote<T>: Stroke where T: Stroke {

    // MARK: - Initializers

    public init(
        _ quoteType: QuoteType = .double,
        @Calligraphy content: () -> T
    ) {
        self.quoteType = quoteType
        self.content = content()
    }

    // MARK: - API

    public enum QuoteType: String, Equatable, Sendable {
        case single = "'"
        case double = "\""
        case triple = "'''"
    }

    // MARK: - Stroke

    public var body: some Stroke {
        Delimited {
            content
        } delimiter: {
            quoteType
        }
    }

    // MARK: - Private

    private let content: T
    private let quoteType: QuoteType

}
