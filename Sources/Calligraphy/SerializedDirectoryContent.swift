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

/// Serialized representaion of directory content
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum SerializedDirectoryContent: Equatable, Sendable {

    // MARK: - API

    /// A serialized directory
    case directory(Directory)

    /// A serialized file
    case file(File)

    /// Create a serialized directory
    /// - Parameters:
    ///   - name: The name of the directory
    ///   - contents: The directory's contents
    /// - Returns: The directory content
    public static func directory(
        _ name: String,
        contents: [SerializedDirectoryContent]
    ) -> SerializedDirectoryContent {
        .directory(
            .init(
                name,
                contents: contents
            )
        )
    }

    /// Create a serialized text file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - contents: The file's contents
    ///   - encoding: The file's string encoding
    /// - Returns: The directory content
    public static func text(
        _ name: String,
        contents: String,
        encoding: String.Encoding
    ) -> SerializedDirectoryContent {
        .file(
            .text(
                name,
                content: contents,
                encoding: encoding
            )
        )
    }

    /// Create a serialized binary file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - contents: The file's contents
    /// - Returns: The directory content
    public static func binary(
        _ name: String,
        contents: Data
    ) -> SerializedDirectoryContent {
        .file(
            .init(
                name,
                content: .binary(
                    contents
                )
            )
        )
    }

    /// A serialized file
    public struct File: Equatable, Sendable {

        // MARK: - Initializers

        /// Create a serialized file
        /// - Parameters:
        ///   - name: The name of the file
        ///   - content: The file's content
        public init(
            _ name: String,
            content: Content
        ) {
            self.name = name
            self.content = content
        }

        // MARK: - API

        /// Create a serialized text file
        /// - Parameters:
        ///   - name: The name of the file
        ///   - content: The file's content
        ///   - encoding: The file's string encoding
        /// - Returns: The serialized file
        public static func text(
            _ name: String,
            content: String,
            encoding: String.Encoding
        ) -> File {
            .init(
                name,
                content: .text(
                    content,
                    encoding
                )
            )
        }

        /// Create a serialized binary file
        /// - Parameters:
        ///   - name: The name of the file
        ///   - content: The file's content
        /// - Returns: The serialized file
        public static func binary(
            _ name: String,
            content: Data
        ) -> File {
            .init(
                name,
                content: .binary(
                    content
                )
            )
        }

        /// Serialized file content
        public enum Content: Equatable, Sendable {

            /// Text content
            case text(String, String.Encoding)

            /// Binary content
            case binary(Data)

        }

        /// The name of the file
        public let name: String

        /// The file's content
        public let content: Content

    }

    /// A serialized directory
    public struct Directory: Equatable, Sendable {

        // MARK: - Initializers

        /// Create a serialized directory
        /// - Parameters:
        ///   - name: The name of the directory
        ///   - contents: The directory's content
        public init(
            _ name: String,
            contents: [SerializedDirectoryContent]
        ) {
            self.name = name
            self.contents = contents
        }

        // MARK: - API

        /// The name of the directory
        public let name: String

        /// The directory's content
        public let contents: [SerializedDirectoryContent]

    }

}
