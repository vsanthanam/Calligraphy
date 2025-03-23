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

/// Generic directory content
///
/// - Important: You shouldn't implement this protocol directly. Instead, implement either ``Directory`` or ``File``
@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public protocol DirectoryContent: Sendable {

    /// Serialized the directory content
    func _serialize() -> [SerializedDirectoryContent]
}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public extension DirectoryContent {

    /// Write the contents to a directory
    /// - Parameters:
    ///   - directoryURL: The directory to write the contents to
    ///   - encoding: The string encoding, to use for files
    ///   - shouldOverwrite: Whether or not existing files and folder should be overwritten.
    /// - Returns: The URLs of the files and folders that were created
    /// - Throws: An error, if the operation fails or was cancelled.
    @discardableResult
    func write(
        toDirectory directoryURL: URL,
        encoding: String.Encoding = .utf8,
        shouldOverwrite: Bool = false
    ) async throws -> [URL] {
        let operation = try DirectoryOperation(
            directoryURL: directoryURL,
            encoding: encoding,
            shouldOverwrite: shouldOverwrite
        )
        return try await DirectoryOperation.start(operation) {
            let content = _serialize()
            return try await content.performWriteOperations()
        }
    }

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
private extension [SerializedDirectoryContent] {

    func performWriteOperations() async throws -> [URL] {
        try await withThrowingTaskGroup(of: [URL].self) { group in
            for content in self {
                group.addTask {
                    try await content.performWriteOperation()
                }
            }
            var rv = [URL]()
            do {
                for try await urls in group {
                    rv += urls
                }
                return rv
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }

}

@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
private extension SerializedDirectoryContent {

    func performWriteOperation() async throws -> [URL] {
        guard let operation = DirectoryOperation.current else {
            throw DirectoryError("No operation in progress")
        }
        var current = operation.directoryURL
        for path in DirectoryOperation.path {
            current = current.appending(
                path: path,
                directoryHint: .isDirectory
            )
        }

        func deleteIfNeeded(
            _ url: URL,
            _ shouldOverwrite: Bool
        ) async throws {
            guard shouldOverwrite else { return }
            if FileManager.default.fileExists(atPath: url.path()) {
                try FileManager.default.removeItem(at: url)
                try Task.checkCancellation()
            }
        }
        let rv: [URL]
        switch self {
        case let .file(name, content):
            let fileURL = current.appending(
                path: name,
                directoryHint: .notDirectory
            )
            try await deleteIfNeeded(fileURL, operation.shouldOverwrite)
            try content.write(
                to: fileURL,
                atomically: true,
                encoding: operation.encoding
            )
            rv = [fileURL]
        case let .directory(name, content):
            let directoryURL = current.appending(
                path: name,
                directoryHint: .isDirectory
            )
            try await deleteIfNeeded(directoryURL, operation.shouldOverwrite)
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: false
            )
            let urls = try await DirectoryOperation.push(name) {
                try await content.performWriteOperations()
            }
            rv = [directoryURL] + urls
        }
        try Task.checkCancellation()
        return rv
    }

}
