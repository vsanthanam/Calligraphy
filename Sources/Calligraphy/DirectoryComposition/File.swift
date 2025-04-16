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
public struct File: DirectoryContent {

    // MARK: - Initializers

    /// Create a text file using a @StringBuilder
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The file's permissions
    ///   - encoding: The file's encoding
    ///   - text: The contents of the file
    public init(
        _ name: String,
        permissions: FilePermissions = .default,
        encoding: String.Encoding = .utf8,
        @StringBuilder text: () -> some StringComponent
    ) {
        backing = .text(
            name,
            permissions: permissions,
            text: String.build(text),
            encoding: encoding
        )
    }

    /// Create a text file with a file extension using a @StringBuilder
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The file's permissions
    ///   - encoding: The file's encoding
    ///   - text: The contents of the file
    public init(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions = .default,
        encoding: String.Encoding = .utf8,
        @StringBuilder text: () -> some StringComponent
    ) {
        backing = .text(
            name,
            fileExtension: fileExtension,
            permissions: permissions,
            text: String.build(text),
            encoding: encoding
        )
    }

    /// Create a text file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The file's permissions
    ///   - text: The contents of the file
    ///   - encoding: The file's encoding
    public init(
        _ name: String,
        permissions: FilePermissions = .default,
        text: String,
        encoding: String.Encoding = .utf8,
    ) {
        self.init(
            name,
            permissions: permissions,
            encoding: encoding
        ) {
            text
        }
    }

    /// Create a text file with a file extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The file's permissions
    ///   - text: The contents of the file
    ///   - encoding: The file's encoding
    public init(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions = .default,
        text: String,
        encoding: String.Encoding = .utf8,
    ) {
        self.init(
            name,
            fileExtension: fileExtension,
            permissions: permissions,
            encoding: encoding
        ) {
            text
        }
    }

    /// Create a data file using a @DataBuilder
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The file's permissions
    ///   - data: The contents of the file
    public init(
        _ name: String,
        permissions: FilePermissions = .default,
        @DataBuilder data: () -> some DataComponent
    ) {
        backing = .data(
            name,
            permissions: permissions,
            data: Data.build(data)
        )
    }

    /// Create a data file with a file extension using a @DataBuilder
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The file's permissions
    ///   - data: The contents of the file
    public init(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions = .default,
        @DataBuilder data: () -> some DataComponent
    ) {
        backing = .data(
            name,
            fileExtension: fileExtension,
            permissions: permissions,
            data: Data.build(data)
        )
    }

    /// Create a data file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - permissions: The file's permissions
    ///   - data: The contents of the file
    public init(
        _ name: String,
        permissions: FilePermissions = .default,
        data: Data
    ) {
        self.init(
            name,
            permissions: permissions
        ) {
            data
        }
    }

    /// Create a data file with a file extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension
    ///   - permissions: The file's permissions
    ///   - data: The contents of the file
    public init(
        _ name: String,
        fileExtension: String,
        permissions: FilePermissions = .default,
        data: Data
    ) {
        self.init(
            name,
            fileExtension: fileExtension,
            permissions: permissions
        ) {
            data
        }
    }

    // MARK: - DirectoryContent

    public func _serialize() -> [SerializedDirectoryContent] {
        [backing]
    }

    // MARK: - Private

    private let backing: SerializedDirectoryContent

}

//    // MARK: - Initializers
//
//    /// Create a text file, declaratively
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - permissions: The file's permissions
//    ///   - encoding: The string encoding to use when the file is written to disk
//    ///   - text: The text in the file
//    public init(
//        _ name: String,
//        permissions: FilePermissions = .default,
//        encoding: String.Encoding = .utf8,
//        @StringBuilder text: () -> some StringComponent
//    ) {
//        self.init(
//            name,
//            permissions,
//            .text(
//                String.build(text),
//                encoding
//            )
//        )
//    }
//
//    /// Create a text file with a file extension, declaratively
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - extension: The file extension
//    ///   - permissions: The file's permissions
//    ///   - encoding: The string encoding to use when the file is written to disk
//    ///   - text: The text in the file
//    public init(
//        _ name: String,
//        extension: String,
//        permissions: FilePermissions = .default,
//        encoding: String.Encoding = .utf8,
//        @StringBuilder text: () -> some StringComponent
//    ) {
//        self.init(
//            name,
//            `extension`,
//            permissions,
//            .text(
//                String.build(text),
//                encoding
//            )
//        )
//    }
//
//    /// Create a text file
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - permissions: The file's permissions
//    ///   - encoding: The string encoding to use when the file is written to disk
//    ///   - text: The text in the file
//    public init(
//        _ name: String,
//        permissions: FilePermissions = .default,
//        encoding: String.Encoding = .utf8,
//        text: String
//    ) {
//        self.init(
//            name,
//            permissions: permissions,
//            encoding: encoding
//        ) {
//            text
//        }
//    }
//
//    /// Create a text file with a file extension, declaratively
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - extension: The file extension
//    ///   - permissions: The file's permissions
//    ///   - encoding: The string encoding to use when the file is written to disk
//    ///   - text: The text in the file
//    public init(
//        _ name: String,
//        extension: String,
//        permissions: FilePermissions = .default,
//        encoding: String.Encoding = .utf8,
//        text: String
//    ) {
//        self.init(
//            name,
//            extension: `extension`,
//            permissions: permissions,
//            encoding: encoding
//        ) {
//            text
//        }
//    }
//
//    /// Create a data file, declaratively
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - permissions: The file's permissions
//    ///   - data: The data in the file
//    public init(
//        _ name: String,
//        permissions: FilePermissions = .default,
//        @DataBuilder data: () -> some DataComponent
//    ) {
//        self.init(
//            name,
//            permissions,
//            .data(
//                Data(components: data)
//            )
//        )
//    }
//
//    /// Create a data file with a file extension, declaratively
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - extension: The file extension
//    ///   - permissions: The file's permissions
//    ///   - data: The data in the file
//    public init(
//        _ name: String,
//        extension: String,
//        permissions: FilePermissions = .default,
//        @DataBuilder data: () -> some DataComponent
//    ) {
//        self.init(
//            name,
//            `extension`,
//            permissions,
//            .data(
//                Data(components: data)
//            )
//        )
//    }
//
//    /// Create a data file
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - permissions: The file's permissions
//    ///   - data: The data in the file
//    public init(
//        _ name: String,
//        permissions: FilePermissions = .default,
//        data: Data
//    ) {
//        self.init(
//            name,
//            permissions: permissions
//        ) {
//            data
//        }
//    }
//
//    /// Create a data file with a file extension
//    /// - Parameters:
//    ///   - name: The name of the file
//    ///   - extension: The file extension
//    ///   - permissions: The file's permissions
//    ///   - data: The data in the file
//    public init(
//        _ name: String,
//        extension: String,
//        permissions: FilePermissions = .default,
//        data: Data
//    ) {
//        self.init(
//            name,
//            extension: `extension`,
//            permissions: permissions
//        ) {
//            data
//        }
//    }
//
//    // MARK: - DirectoryContent
//
//    public func _serialize() -> [SerializedDirectoryContent] {
//        [
//            .file(backing)
//        ]
//    }
//
//    // MARK: - Private
//
//    private init(
//        _ name: String,
//        _ permissions: FilePermissions,
//        _ content: SerializedDirectoryContent.File.Content
//    ) {
//        backing = .init(
//            name,
//            permissions: permissions,
//            content: content
//        )
//    }
//
//    private init(
//        _ name: String,
//        _ extension: String,
//        _ permissions: FilePermissions,
//        _ content: SerializedDirectoryContent.File.Content
//    ) {
//        let name = name + "." + `extension`
//        self.init(
//            name,
//            permissions,
//            content
//        )
//    }
//
//    private let backing: SerializedDirectoryContent.File
//
// }
