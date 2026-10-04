// Calligraphy
// FileEnvironment.swift
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

extension EnvironmentValues {

    @Entry
    var fileName: String?

}

/// A property wrapper that reads the name of the file currently being rendered.
///
/// ``File``, ``TextFile``, and ``DataFile`` set the file name, including its extension, before rendering their contents, so any ``StringComponent`` or ``DataComponent`` inside a file can read it:
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingFileName", slice: "header")
///
/// The value is `nil` when a component is rendered outside of any file. It is also `nil` when read on a file type itself, which already knows its own ``TextFile/name``; the file name is visible to the file's ``TextFile/body``, not to the file's own properties.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper
public struct FileName: EnvironmentPropertyWrapper {

    // MARK: - Initializers

    /// Read the name of the file currently being rendered.
    public init() {}

    // MARK: - Property Wrapper

    /// The name of the file currently being rendered, including its extension, or `nil` outside of any file.
    public var wrappedValue: String? {
        fileName
    }

    // MARK: - Private

    @Environment(\.fileName)
    private var fileName

    func inject(
        _ values: EnvironmentValues
    ) {
        _fileName.inject(values)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    func fileName(
        _ fileName: String
    ) -> some StringComponent {
        environment(
            \.fileName,
            fileName
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataComponent {

    func fileName(
        _ fileName: String
    ) -> some DataComponent {
        environment(
            \.fileName,
            fileName
        )
    }

}
