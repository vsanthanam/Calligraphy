// Calligraphy
// DirectoryComponent.swift
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

/// A directory component
///
/// A `DirectoryComponent` is a type that represents the contents of a directory. When serialized, it could represent one or more files or folders
///
/// Typically, you will not create types that conform to this protocol. Instead, implement ``Directory``, ``TextFile`` or ``DataFile``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DirectoryComponent: Sendable {

    func _serialize() -> [SerializedDirectoryContent]

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DirectoryComponent {

    /// Write the contents of a directory to a file URL, in parallel
    /// - Parameter directoryURL: The a file URL
    /// - Returns: The URLs of every file and directory that was written to disk.
    @discardableResult
    public func write(
        to directoryURL: URL
    ) async throws -> [URL] {
        guard directoryURL.isFileURL else {
            throw DiskOperationError("Provided URL is not a file URL")
        }
        guard let isDirectory = try directoryURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
              isDirectory else {
            throw DiskOperationError("Provided URL does not point to a directory")
        }
        return try await DiskOperation.start(with: directoryURL) {
            let contents = _serialize()
            try contents.validate(in: "root")
            return try await contents.performWriteOperations()
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent.File {

    fileprivate func write(
        to fileURL: URL
    ) async throws {
        switch content {
        case let .data(data):
            try data.write(
                to: fileURL,
                options: .withoutOverwriting
            )
        case let .text(text, encoding):
            try text.write(
                to: fileURL,
                atomically: false,
                encoding: encoding
            )
        }
        try Task.checkCancellation()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent.Directory {

    fileprivate func write(
        to directoryURL: URL
    ) async throws {
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        try Task.checkCancellation()
    }

    fileprivate func validate() throws {
        try children.validate(in: name)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent {

    fileprivate func performWriteOperation() async throws -> [URL] {
        switch self {
        case let .file(file):
            let url = try DiskOperation.currentURL.appending(path: file.name, directoryHint: .notDirectory)
            try await file.write(to: url)
            return [url]
        case let .directory(directory):
            let url = try DiskOperation.currentURL.appending(path: directory.name, directoryHint: .isDirectory)
            try await directory.write(to: url)
            let urls = try await DiskOperation.push(path: directory.name) {
                try await directory.children.performWriteOperations()
            }
            return [url] + urls
        }
    }

    fileprivate func validate() throws {
        switch self {
        case .file:
            break
        case let .directory(directory):
            try directory.validate()
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension [SerializedDirectoryContent] {

    fileprivate func validate(in parent: String) throws {
        let uniqueNames = Set<String>()
        for content in self {
            guard !uniqueNames.contains(content.name) else {
                throw DiskOperationError("Invalid directory content - duplicate files or directories named '\(content.name)' found in parent '\(parent)'")
            }
            try content.validate()
        }
    }

    fileprivate func performWriteOperations() async throws -> [URL] {
        try await withThrowingTaskGroup(of: [URL].self) { group in
            for content in self {
                group.addTask {
                    try await content.performWriteOperation()
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
                currentURL = currentURL.appending(path: path, directoryHint: .isDirectory)
            }
            return currentURL
        }
    }

    @TaskLocal
    private static var rootURL: URL?

    @TaskLocal
    private static var path: [String] = []

}
