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

/// A serializable representation of a directory entry, either a file or folder.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct SerializedDirectoryContent: Equatable, Hashable, Codable, Sendable {

    // MARK: - API

    /// A directory content
    /// - Parameters:
    ///   - name: The name of the directory
    ///   - permissions: The permisions of the directory
    ///   - content: The directory's children
    /// - Returns: The serialized content
    public static func directory(
        _ name: String,
        permissions: FilePermissions,
        content: [SerializedDirectoryContent]
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            permissions: permissions,
            content: .directory(content)
        )
    }

    /// A data file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The permisions of the file
    ///   - data: The file's contents
    /// - Returns: The serialized content
    public static func data(
        _ name: String,
        permissions: FilePermissions,
        data: Data
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            permissions: permissions,
            content: .data(data)
        )
    }

    /// A data file with a file extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The permisions of the file
    ///   - data: The file's content
    /// - Returns: The serialized content
    public static func data(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions,
        data: Data
    ) -> SerializedDirectoryContent {
        .data(
            name + "." + fileExtension,
            permissions: permissions,
            data: data
        )
    }

    /// A text file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The permisions of the file
    ///   - text: The contents of the file
    ///   - encoding: The string encoding to use when writing the file to disk
    /// - Returns: The serialized content
    public static func text(
        _ name: String,
        permissions: FilePermissions,
        text: String,
        encoding: String.Encoding
    ) -> SerializedDirectoryContent {
        .init(
            name: name,
            permissions: permissions,
            content: .text(text, encoding: encoding)
        )
    }

    /// A text file with a file extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The permisions of the file
    ///   - text: The contents of the file
    ///   - encoding: The string encoding to use when writing the file to disk
    /// - Returns: The serialized content
    public static func text(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions,
        text: String,
        encoding: String.Encoding
    ) -> SerializedDirectoryContent {
        .text(
            name + "." + fileExtension,
            permissions: permissions,
            text: text,
            encoding: encoding
        )
    }

    /// The name of the content
    public let name: String

    /// The permissions of the content
    public let permissions: FilePermissions

    /// The content
    public let content: Content

    /// The available kinds of directory content
    public enum Content: Equatable, Hashable, Codable, Sendable {

        // MARK: - API

        /// A directorry
        case directory([SerializedDirectoryContent])

        /// A file
        case file(File)

        /// A text file
        /// - Parameters:
        ///   - content: The text content of the file
        ///   - encoding: The encoding of the file
        /// - Returns: The content
        public static func text(
            _ content: String,
            encoding: String.Encoding
        ) -> Content {
            .file(
                .text(
                    content,
                    encoding
                )
            )
        }

        /// A data file
        /// - Parameter data: The data content of the file
        /// - Returns: The content
        public static func data(
            _ data: Data
        ) -> Content {
            .file(
                .data(
                    data
                )
            )
        }

        /// The available kinds of files
        public enum File: Equatable, Hashable, Codable, Sendable {

            /// A data file
            case data(Data)

            /// A text file
            case text(String, String.Encoding)

            // MARK: - Codable

            public init(
                from decoder: any Decoder
            ) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(CaseType.self, forKey: .type)
                switch type {
                case .data:
                    self = try .data(container.decode(Data.self, forKey: .data))
                case .text:
                    let encoding = try String.Encoding(rawValue: container.decode(String.Encoding.RawValue.self, forKey: .encoding))
                    let text = try container.decode(String.self, forKey: .text)
                    self = .text(text, encoding)
                }
            }

            public func encode(
                to encoder: any Encoder
            ) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case let .data(data):
                    try container.encode(CaseType.data, forKey: .type)
                    try container.encode(data, forKey: .data)
                case let .text(text, encoding):
                    try container.encode(CaseType.text, forKey: .type)
                    try container.encode(text, forKey: .text)
                    try container.encode(encoding.rawValue, forKey: .encoding)
                }
            }

            // MARK: - Private

            enum CodingKeys: String, CodingKey {
                case data
                case text
                case encoding
                case type
            }

            enum CaseType: String, Codable {
                case data
                case text
            }

        }

    }

}
