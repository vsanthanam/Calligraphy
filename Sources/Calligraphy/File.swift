// Calligraphy
// File.swift
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

/// A generic, composable file
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct File<T>: TextFile where T: Stroke {

    // MARK: - Initializers

    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        @Calligraphy content: () -> T
    ) {
        self.name = name
        self.encoding = encoding
        self.content = content()
    }

    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        @Calligraphy content: () -> T
    ) {
        let name = name + "." + `extension`
        self.init(name, content: content)
    }

    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        content: String
    ) where T == StringStroke {
        self.init(
            name,
            encoding: encoding
        ) { content }
    }

    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        content: String
    ) where T == StringStroke {
        self.init(
            name,
            extension: `extension`,
            encoding: encoding
        ) { content }
    }

    // MARK: - TextFile

    public let name: String

    public let encoding: String.Encoding

    // MARK: - Stroke

    public var body: some Stroke {
        content
    }

    // MARK: - Private

    private let content: T

}
