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

/// A re-usable, composable file
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct File: DirectoryComponent {

    // MARK: - Initializers

    /// Create a text file, declaratively
    /// - Parameters:
    ///   - name: The name of the file
    ///   - encoding: The string encoding to use when the file is written to disk
    ///   - text: The text in the file
    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        @StringBuilder text: () -> some StringComponent
    ) {
        self.init(
            name,
            .text(
                String(components: text),
                encoding
            )
        )
    }

    /// Create a text file with a file extension, declaratively
    /// - Parameters:
    ///   - name: The name of the file
    ///   - extension: The file extension
    ///   - encoding: The string encoding to use when the file is written to disk
    ///   - text: The text in the file
    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        @StringBuilder text: () -> some StringComponent
    ) {
        self.init(
            name,
            `extension`,
            .text(
                String(components: text),
                encoding
            )
        )
    }

    /// Create a text file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - encoding: The string encoding to use when the file is written to disk
    ///   - text: The text in the file
    public init(
        _ name: String,
        encoding: String.Encoding = .utf8,
        text: String
    ) {
        self.init(
            name,
            encoding: encoding
        ) {
            text
        }
    }

    /// Create a text file with a file extension, declaratively
    /// - Parameters:
    ///   - name: The name of the file
    ///   - extension: The file extension
    ///   - encoding: The string encoding to use when the file is written to disk
    ///   - text: The text in the file
    public init(
        _ name: String,
        extension: String,
        encoding: String.Encoding = .utf8,
        text: String
    ) {
        self.init(
            name,
            extension: `extension`,
            encoding: encoding
        ) {
            text
        }
    }

    /// Create a data file, declaratively
    /// - Parameters:
    ///   - name: The name of the file
    ///   - data: The data in the file
    public init(
        _ name: String,
        @DataBuilder data: () -> some DataComponent
    ) {
        self.init(
            name,
            .data(
                Data(components: data)
            )
        )
    }

    /// Create a data file with a file extension, declaratively
    /// - Parameters:
    ///   - name: The name of the file
    ///   - extension: The file extension
    ///   - data: The data in the file
    public init(
        _ name: String,
        extension: String,
        @DataBuilder data: () -> some DataComponent
    ) {
        self.init(
            name,
            `extension`,
            .data(
                Data(components: data)
            )
        )
    }

    /// Create a data file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - data: The data in the file
    public init(
        _ name: String,
        data: Data
    ) {
        self.init(
            name
        ) {
            data
        }
    }

    /// Create a data file with a file extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - extension: The file extension
    ///   - data: The data in the file
    public init(
        _ name: String,
        extension: String,
        data: Data
    ) {
        self.init(
            name,
            extension: `extension`
        ) {
            data
        }
    }

    // MARK: - DirectoryComponent

    public func _serialize() -> [SerializedDirectoryContent] {
        [
            .file(backing)
        ]
    }

    // MARK: - Private

    private init(
        _ name: String,
        _ content: SerializedDirectoryContent.File.Content
    ) {
        backing = .init(
            name,
            content: content
        )
    }

    private init(
        _ name: String,
        _ extension: String,
        _ content: SerializedDirectoryContent.File.Content
    ) {
        let name = name + "." + `extension`
        self.init(
            name,
            content
        )
    }

    private let backing: SerializedDirectoryContent.File

}
