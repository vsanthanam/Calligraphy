// Calligraphy
// FileURL.swift
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

/// A property wrapper that reads the URL of the file currently being rendered.
///
/// The URL is absolute, so it is only available while content is being written with ``DirectoryContent/write(to:shouldOverwrite:)``:
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingFileLocation", slice: "url")
///
/// The value is `nil` when a component is rendered outside of any file, or when the content is serialized without a destination. Like ``FileName``, it is visible to a file's body, not to the file's own properties. Use ``FilePath`` when a relative location is enough.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper
public struct FileURL: DynamicProperty {

    // MARK: - Initializers

    /// Read the URL of the file currently being rendered.
    public init() {}

    // MARK: - Property Wrapper

    /// The absolute file URL of the file currently being rendered, or `nil` when it cannot be determined.
    public var wrappedValue: URL? {
        guard let fileName else {
            return nil
        }
        return location.url(
            to: enclosing + [fileName],
            isDirectory: false
        )
    }

    // MARK: - Private

    @Environment(\.fileName)
    private var fileName

    @Environment(\.enclosingDirectoryComponents)
    private var enclosing

    @FileLocationEnvironment
    private var location

}
