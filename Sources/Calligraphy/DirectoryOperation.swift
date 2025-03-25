// Calligraphy
// DirectoryOperation.swift
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

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public extension DirectoryContent {

    /// Write the contents to a directory, in asynchronously and in parallel
    /// - Parameters:
    ///   - directoryURL: The directory to write the contents to
    ///   - encoding: The string encoding to use for files
    ///   - shouldOverwrite: Whether or not existing files and folder should be overwritten
    /// - Returns: The URLs of the files and folders that were created
    /// - Throws: An error, if the operation fails or was cancelled
    @discardableResult
    func write(
        toDirectory directoryURL: URL,
        encoding: String.Encoding = .utf8,
        shouldOverwrite: Bool = false
    ) async throws -> [URL] {
        try await DirectoryOperation.start(
            on: directoryURL,
            encoding: encoding,
            shouldOverwrite: shouldOverwrite
        ) {
            try await _serialize().performWriteOperationsAsync()
        }
    }

    /// Write the contents to a directory,
    /// - Parameters:
    ///   - directoryURL: The directory to write the contents to
    ///   - encoding: The string encoding to use for files
    ///   - shouldOverwrite: Whether or not existing files and folder should be overwritten
    /// - Returns: The URLs of the files and folders that were created
    /// - Throws: An error, if the operation fails
    @discardableResult
    func write(
        toDirectory directoryURL: URL,
        encoding: String.Encoding = .utf8,
        shouldOverwrite: Bool = false
    ) throws -> [URL] {
        try DirectoryOperation.start(
            on: directoryURL,
            encoding: encoding,
            shouldOverwrite: shouldOverwrite
        ) {
            try _serialize().performWriteOperationsSync()
        }
    }

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
private struct DirectoryOperation: Equatable, Sendable {

    static func start<R>(
        on rootDirectoryURL: URL,
        encoding: String.Encoding,
        shouldOverwrite: Bool,
        fn: @Sendable () async throws -> R
    ) async throws -> R {
        let operation = try DirectoryOperation(
            rootDirectoryURL: rootDirectoryURL,
            encoding: encoding,
            shouldOverwrite: shouldOverwrite
        )
        return try await $active.withValue(
            operation,
            operation: fn
        )
    }

    static func start<R>(
        on rootDirectoryURL: URL,
        encoding: String.Encoding,
        shouldOverwrite: Bool,
        fn: @Sendable () throws -> R
    ) throws -> R {
        let operation = try DirectoryOperation(
            rootDirectoryURL: rootDirectoryURL,
            encoding: encoding,
            shouldOverwrite: shouldOverwrite
        )
        return try $active.withValue(
            operation,
            operation: fn
        )
    }

    static func push<R>(
        _ next: String,
        fn: @Sendable () async throws -> R
    ) async rethrows -> R {
        try await $path.withValue(
            path + [next],
            operation: fn
        )
    }

    static func push<R>(
        _ next: String,
        fn: @Sendable () throws -> R
    ) rethrows -> R {
        try $path.withValue(
            path + [next],
            operation: fn
        )
    }

    static var currentOperationState: State {
        get throws {
            guard let active else {
                throw DirectoryError("No operation in progress")
            }
            var currentURL = active.rootDirectoryURL
            for path in path {
                currentURL = currentURL.appending(
                    path: path,
                    directoryHint: .isDirectory
                )
            }
            return .init(
                active,
                currentURL
            )
        }
    }

    @dynamicMemberLookup
    struct State: Equatable, Sendable {

        init(
            _ operation: DirectoryOperation,
            _ currentURL: URL
        ) {
            self.operation = operation
            self.currentURL = currentURL
        }

        private let operation: DirectoryOperation

        private let currentURL: URL

        func fileURL(
            for path: String
        ) -> URL {
            currentURL.appending(
                path: path,
                directoryHint: .notDirectory
            )
        }

        func directoryURL(
            for path: String
        ) -> URL {
            currentURL.appending(
                path: path,
                directoryHint: .isDirectory
            )
        }

        subscript<T>(
            dynamicMember keyPath: KeyPath<DirectoryOperation, T>
        ) -> T {
            operation[keyPath: keyPath]
        }
    }

    let encoding: String.Encoding

    let shouldOverwrite: Bool

    private init(
        rootDirectoryURL: URL,
        encoding: String.Encoding,
        shouldOverwrite: Bool
    ) throws {
        guard rootDirectoryURL.isFileURL else {
            throw DirectoryError("Provided URL must be a file URL")
        }
        guard FileManager.default.fileExists(atPath: rootDirectoryURL.path()) else {
            throw DirectoryError("Provided URL does not exist")
        }
        let resourceValues = try rootDirectoryURL.resourceValues(forKeys: [.isDirectoryKey])
        guard let isDirectory = resourceValues.isDirectory,
              isDirectory else {
            throw DirectoryError("Provided file URL must point to a directory")
        }
        self.rootDirectoryURL = rootDirectoryURL
        self.encoding = encoding
        self.shouldOverwrite = shouldOverwrite
    }

    private let rootDirectoryURL: URL

    @TaskLocal
    private static var active: DirectoryOperation?

    @TaskLocal
    private static var path = [String]()

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
private extension [SerializedDirectoryContent] {

    func performWriteOperationsAsync() async throws -> [URL] {
        try await withThrowingTaskGroup(of: [URL].self) { group in
            for content in self {
                group.addTask {
                    try await content.performWriteOperationAsync()
                }
            }
            do {
                var urls = [URL]()
                while !group.isEmpty {
                    urls += try await group.next() ?? []
                }
                return urls
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }

    func performWriteOperationsSync() throws -> [URL] {
        try flatMap { content in try content.performWriteOperationSync() }
    }

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
private extension SerializedDirectoryContent {

    func performWriteOperationAsync() async throws -> [URL] {
        let state = try DirectoryOperation.currentOperationState
        func deleteIfNeeded(
            _ url: URL
        ) async throws {
            guard state.shouldOverwrite else { return }
            if FileManager.default.fileExists(atPath: url.path()) {
                try FileManager.default.removeItem(at: url)
                try Task.checkCancellation()
            }
        }
        let urls: [URL]
        switch self {
        case let .file(file):
            let fileURL = state.fileURL(for: file.name)
            try await deleteIfNeeded(fileURL)
            try file.content.write(
                to: fileURL,
                atomically: true,
                encoding: state.encoding
            )
            urls = [fileURL]
        case let .directory(directory):
            let directoryURL = state.directoryURL(for: directory.name)
            try await deleteIfNeeded(directoryURL)
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: false
            )
            let childURLs = try await DirectoryOperation.push(directory.name) {
                try await directory.contents.performWriteOperationsAsync()
            }
            urls = [directoryURL] + childURLs
        }
        try Task.checkCancellation()
        return urls
    }

    func performWriteOperationSync() throws -> [URL] {
        let state = try DirectoryOperation.currentOperationState
        func deleteIfNeeded(
            _ url: URL
        ) throws {
            guard state.shouldOverwrite else { return }
            if FileManager.default.fileExists(atPath: url.path()) {
                try FileManager.default.removeItem(at: url)
            }
        }
        let urls: [URL]
        switch self {
        case let .file(file):
            let fileURL = state.fileURL(for: file.name)
            try deleteIfNeeded(fileURL)
            try file.content.write(
                to: fileURL,
                atomically: true,
                encoding: state.encoding
            )
            urls = [fileURL]
        case let .directory(directory):
            let directoryURL = state.directoryURL(for: directory.name)
            try deleteIfNeeded(directoryURL)
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: false
            )
            let childURLs = try DirectoryOperation.push(directory.name) {
                try directory.contents.performWriteOperationsSync()
            }
            urls = [directoryURL] + childURLs
        }
        return urls
    }

}
