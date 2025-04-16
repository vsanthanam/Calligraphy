// Calligraphy
// SerializedDirectoryContent.swift
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
public struct SerializedDirectoryContent: Equatable, Sendable {

    public static func directory(
        _ name: String,
        content: [SerializedDirectoryContent]
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            content: .directory(content)
        )
    }

    public static func data(
        _ name: String,
        data: Data
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            content: .file(
                .data(
                    data
                )
            )
        )
    }

    public static func data(
        _ name: String,
        fileExtension: String,
        data: Data
    ) -> SerializedDirectoryContent {
        .data(
            name + "." + fileExtension,
            data: data
        )
    }

    public static func text(
        _ name: String,
        text: String,
        encoding: String.Encoding
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            content: .file(
                .text(
                    text,
                    encoding
                )
            )
        )
    }

    public static func text(
        _ name: String,
        fileExtension: String,
        text: String,
        encoding: String.Encoding
    ) -> SerializedDirectoryContent {
        .init(
            name: name + "." + fileExtension,
            content: .file(.text(text, encoding))
        )
    }

    public let name: String

    public let content: Content

    public enum Content: Equatable, Sendable {

        case directory([SerializedDirectoryContent])

        case file(File)

        public enum File: Equatable, Sendable {
            case data(Data)
            case text(String, String.Encoding)
        }

    }

}
