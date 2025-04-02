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
public struct File: DataFile {

    // MARK: - Initializers

    public init(
        _ name: String,
        data: Data
    ) {
        self.name = name
        self.data = data
    }

    public init(
        _ name: String,
        extension: String,
        data: Data
    ) {
        self.init(
            name + "." + `extension`,
            data: data
        )
    }

    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        @Calligraphy content: () -> some Stroke
    ) {
        self.init(
            name,
            data: String(calligraphy: content).data(using: encoding)!
        )
    }

    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        @Calligraphy content: () -> some Stroke
    ) {
        self.init(
            name,
            extension: `extension`,
            data: String(calligraphy: content).data(using: encoding)!
        )
    }

    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        content: String
    ) {
        self.init(
            name,
            encoding: encoding
        ) {
            content
        }
    }

    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        content: String
    ) {
        self.init(
            name,
            extension: `extension`,
            encoding: encoding
        ) {
            content
        }
    }

    // MARK: - DataFile

    public let name: String

    public let data: Data

}
