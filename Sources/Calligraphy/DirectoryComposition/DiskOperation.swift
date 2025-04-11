// Calligraphy
// DiskOperation.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DirectoryComponent {

    @discardableResult
    public func write(to directoryURL: URL) async throws -> [URL] {
        try await DiskOperation.start(with: directoryURL) {
            let contents = _serialize()
            return try await contents.performWriteOperations()
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
enum DiskOperation {

    static func start<T>(with rootURL: URL, fn: () async throws -> T) async rethrows -> T {
        try await $rootURL.withValue(rootURL, operation: fn)
    }

    static func push<T>(path newPath: String, fn: () async throws -> T) async rethrows -> T {
        try await $path.withValue(path + [newPath], operation: fn)
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension SerializedDirectoryContent {

    func performWriteOperation() async throws -> [URL] {
        switch self {
        case let .file(file):
            let url = try DiskOperation.currentURL.appending(path: file.name, directoryHint: .notDirectory)
            switch file.content {
            case let .binary(binary):
                try binary.write(to: url, options: .withoutOverwriting)
            case let .text(text, encoding):
                try text.write(to: url, atomically: false, encoding: encoding)
            }
            try Task.checkCancellation()
            return [url]
        case let .directory(directory):
            let url = try DiskOperation.currentURL.appending(path: directory.name, directoryHint: .isDirectory)
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
            try Task.checkCancellation()
            let urls = try await DiskOperation.push(path: directory.name) {
                try await directory.children.performWriteOperations()
            }
            return [url] + urls
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension [SerializedDirectoryContent] {

    func performWriteOperations() async throws -> [URL] {
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
struct DiskOperationError: Error {

    init(_ message: String) {
        self.message = message
    }

    private let message: String

}
