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

/// A serialized representation of the contents of a directory, which can be written to disk
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum SerializedDirectoryContent: Equatable, Sendable {

    // MARK: - API

    /// A directory
    case directory(Directory)

    /// A file
    case file(File)

    public var name: String {
        switch self {
        case let .directory(directory):
            directory.name
        case let .file(file):
            file.name
        }
    }

    /// A serialized directory
    public struct Directory: Equatable, Sendable {

        // MARK: - Initializers

        /// Create a serialized directory
        /// - Parameters:
        ///   - name: The name of the directory
        ///   - children: The directory's children
        public init(
            _ name: String,
            children: [SerializedDirectoryContent]
        ) {
            self.name = name
            self.children = children
        }

        // MARK: - API

        /// The name of the directory
        public let name: String

        /// The directory's children
        public let children: [SerializedDirectoryContent]

    }

    /// A serialized file
    public struct File: Equatable, Sendable {

        // MARK: - Initializers

        /// Create a serialized file
        /// - Parameters:
        ///   - name: The name of the file
        ///   - content: The contents of the file
        public init(
            _ name: String,
            content: Content
        ) {
            self.name = name
            self.content = content
        }

        // MARK: - API

        /// The name of the file
        public let name: String

        /// The contents of the file
        public let content: Content

        /// A serialized file's contents
        public enum Content: Equatable, Sendable {

            // MARK: - API

            /// Data file content
            case data(Data)

            /// Text file content
            case text(String, String.Encoding)

        }

    }

}
