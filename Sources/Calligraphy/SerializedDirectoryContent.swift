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

/// Serialized representaion of directory content
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum SerializedDirectoryContent: Equatable, Hashable, Sendable {

    // MARK: - API

    /// A file
    case file(File)

    /// A directory
    case directory(Directory)

    public struct File: Equatable, Hashable, Sendable {

        // MARK: - Initializers

        public init(
            name: String,
            content: String
        ) {
            self.name = name
            self.content = content
        }

        // MARK: - API

        public let name: String
        public let content: String

    }

    public struct Directory: Equatable, Hashable, Sendable {

        // MARK: - Initializers

        public init(
            name: String,
            contents: [SerializedDirectoryContent]
        ) {
            self.name = name
            self.contents = contents
        }

        // MARK: - API

        public let name: String
        public let contents: [SerializedDirectoryContent]

    }

}
