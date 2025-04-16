// Calligraphy
// DirectoryContent.swift
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

/// A directory content
///
/// A `DirectoryContent` is a type that represents the contents of a directory. When serialized, it could represent one or more files or folders
///
/// Typically, you will not create types that conform to this protocol. Instead, implement ``Directory``, ``TextFile`` or ``DataFile``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DirectoryContent: Sendable {

    func _serialize() -> [SerializedDirectoryContent]

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DirectoryContent {

    /// Write the contents of a directory to a file URL, in parallel
    /// - Parameters:
    ///   - directoryURL: The a file URL to a directory where the content should be written to.
    ///   - shouldOverwrite: Whether or not existing content with the same name or structure should be overwritten with new content.
    /// - Returns: A list of every file URL that was created during the process.
    @discardableResult
    public func write(
        to directoryURL: URL,
        shouldOverwrite: Bool = false
    ) async throws -> [URL] {
        guard directoryURL.isFileURL else {
            throw DiskOperationError("Provided URL is not a file URL")
        }
        guard let isDirectory = try directoryURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
              isDirectory else {
            throw DiskOperationError("Provided URL does not point to a directory")
        }
        let contents = _serialize()
        try contents.validate(in: directoryURL)
        return try await DiskOperation.start(with: directoryURL) {
            try await contents.performWriteOperations(shouldOverwrite: shouldOverwrite)
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent {

    fileprivate func performWriteOperation(
        shouldOverwrite: Bool
    ) async throws -> [URL] {
        switch content {
        case let .directory(directory):
            let url = try DiskOperation.currentURL.appending(directory: name)
            try await FileManager.default.findExisting(at: url, shouldOverwrite: shouldOverwrite)
            try await FileManager.default.createDirectory(at: url)
            let urls = try await DiskOperation.push(path: name) {
                try await directory.performWriteOperations(shouldOverwrite: shouldOverwrite)
            }
            return [url] + urls
        case let .file(file):
            let url = try DiskOperation.currentURL.appending(file: name)
            try await FileManager.default.findExisting(at: url, shouldOverwrite: shouldOverwrite)
            try await file.serialize().write(toURL: url)
            return [url]
        }
    }

    fileprivate func validate(
        in parent: URL
    ) throws {
        switch content {
        case let .directory(directory):
            try directory.validate(in: parent.appending(file: name))
        case .file:
            break
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent.Content.File {

    fileprivate func serialize() async throws -> Data {
        switch self {
        case let .data(data):
            return data
        case let .text(text, encoding):
            guard let data = text.data(using: encoding) else {
                throw DiskOperationError("Invalid string encoding")
            }
            try Task.checkCancellation()
            return data
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension [SerializedDirectoryContent] {

    fileprivate func validate(
        in parent: URL
    ) throws {
        let uniqueNames = Set<String>()
        for content in self {
            guard !uniqueNames.contains(content.name) else {
                throw DiskOperationError("Invalid directory content - duplicate files or directories named '\(content.name)' found in parent '\(parent.path())'")
            }
            try content.validate(in: parent)
        }
    }

    fileprivate func performWriteOperations(
        shouldOverwrite: Bool
    ) async throws -> [URL] {
        try await withThrowingTaskGroup { group in
            for content in self {
                group.addTask {
                    try await content.performWriteOperation(shouldOverwrite: shouldOverwrite)
                }
            }
            do {
                var result = [URL]()
                for try await urls in group {
                    result += urls
                }
                return result
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct DiskOperationError: Error, CustomStringConvertible {

    init(_ message: String) {
        self.message = message
    }

    var description: String {
        message
    }

    private let message: String

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private enum DiskOperation {

    static func start<T>(
        with rootURL: URL,
        fn: () async throws -> T
    ) async rethrows -> T {
        try await $rootURL.withValue(
            rootURL,
            operation: fn
        )
    }

    static func push<T>(
        path newPath: String,
        fn: () async throws -> T
    ) async rethrows -> T {
        try await $path.withValue(
            path + [newPath],
            operation: fn
        )
    }

    static var currentURL: URL {
        get throws {
            guard var currentURL = rootURL else {
                throw DiskOperationError("No operation in progress")
            }
            for path in path {
                currentURL = currentURL.appending(directory: path)
            }
            return currentURL
        }
    }

    @TaskLocal
    private static var rootURL: URL?

    @TaskLocal
    private static var path: [String] = []

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension FileManager {

    fileprivate func createDirectory(
        at url: URL
    ) async throws {
        try createDirectory(
            at: url,
            withIntermediateDirectories: false
        )
        try Task.checkCancellation()
    }

    fileprivate func findExisting(
        at url: URL,
        shouldOverwrite: Bool
    ) async throws {

        func fileOrDirectoryExists(
            at url: URL
        ) -> Bool {
            let resourceKeys: Set<URLResourceKey> = [.isRegularFileKey, .isDirectoryKey]
            if let values = try? url.resourceValues(forKeys: resourceKeys) {
                if let isDirectory = values.isDirectory, isDirectory {
                    return true
                } else if let isRegularFile = values.isRegularFile, isRegularFile {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }

        if fileOrDirectoryExists(at: url) {
            if shouldOverwrite {
                try FileManager.default.removeItem(at: url)
                try Task.checkCancellation()
            } else {
                throw DiskOperationError("File or directory already exists at proposed path '\(url.path())'")
            }
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Data {

    fileprivate func write(
        toURL url: URL
    ) async throws {
        try write(
            to: url,
            options: .withoutOverwriting
        )
        try Task.checkCancellation()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension URL {

    fileprivate func appending(
        directory: String
    ) -> URL {
        appending(
            path: directory,
            directoryHint: .isDirectory
        )
    }

    fileprivate func appending(
        file: String
    ) -> URL {
        appending(
            path: file,
            directoryHint: .notDirectory
        )
    }

}
