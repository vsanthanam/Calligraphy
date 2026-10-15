// Calligraphy
// FilePath.swift
//
// MIT License
//
// Copyright (c) 2026 Varun Santhanam
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

/// A property wrapper that reads the path of the file currently being rendered.
///
/// ``File``, ``TextFile``, and ``DataFile`` set the location of the file before rendering their contents, so any ``StringComponent`` or ``DataComponent`` inside a file can read it. The relative path is measured from the directory the content is written to, and includes the file name:
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingFileLocation", slice: "path")
///
/// The value is `nil` when a component is rendered outside of any file, and `nil` for ``PathResolution/absolute`` when the content is serialized without a destination. Like ``FileName``, it is visible to a file's body, not to the file's own properties.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper
public struct FilePath: DynamicProperty {

    // MARK: - Initializers

    /// Read the path of the file currently being rendered.
    /// - Parameter resolution: Whether to read a path relative to the destination directory, or an absolute path on disk.
    public init(
        _ resolution: PathResolution = .relative
    ) {
        self.resolution = resolution
    }

    // MARK: - Property Wrapper

    /// The path of the file currently being rendered, or `nil` when it cannot be determined.
    public var wrappedValue: String? {
        guard let fileName else {
            return nil
        }
        return location.path(
            to: enclosing + [fileName],
            resolution: resolution
        )
    }

    // MARK: - Private

    private let resolution: PathResolution

    @Environment(\.fileName)
    private var fileName

    @Environment(\.enclosingDirectoryComponents)
    private var enclosing

    @FileLocationEnvironment
    private var location

}
