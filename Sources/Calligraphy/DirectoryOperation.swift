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
struct DirectoryOperation {

    let directoryURL: URL

    let encoding: String.Encoding

    let shouldOverwrite: Bool

    @TaskLocal
    static var current: DirectoryOperation?

    @TaskLocal
    static var path = [String]()

    init(
        directoryURL: URL,
        encoding: String.Encoding,
        shouldOverwrite: Bool
    ) throws {
        guard directoryURL.isFileURL else {
            throw DirectoryError("Provided URL must be a file URL")
        }
        guard FileManager.default.fileExists(atPath: directoryURL.path()) else {
            throw DirectoryError("Provided URL does not exist")
        }
        let resourceValues = try directoryURL.resourceValues(forKeys: [.isDirectoryKey])
        guard let isDirectory = resourceValues.isDirectory,
              isDirectory else {
            throw DirectoryError("Provided file URL must point to a directory")
        }
        self.directoryURL = directoryURL
        self.encoding = encoding
        self.shouldOverwrite = shouldOverwrite
    }

    static func start<R>(
        _ operation: DirectoryOperation,
        fn: () async throws -> R
    ) async throws -> R {
        try await $current.withValue(operation, operation: fn)
    }

    static func push<R>(
        _ next: String,
        fn: () async throws -> R
    ) async rethrows -> R {
        try await $path.withValue(path + [next], operation: fn)
    }

}
