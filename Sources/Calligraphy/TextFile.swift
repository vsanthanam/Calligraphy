// Calligraphy
// TextFile.swift
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

/// A generic, composable text file
@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct TextFile<T>: File where T: Stroke {

    // MARK: - Initializers

    /// Create a text file with an extension
    /// - Parameters:
    ///   - name: The name of the file
    ///   - extension: The file's extension
    ///   - content: The file's content
    public init(
        _ name: String,
        extension: String,
        @Calligraphy content: () -> T
    ) {
        self.init(name + "." + `extension`, content: content)
    }

    /// Create a text file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - content: The file's content
    public init(
        _ name: String,
        @Calligraphy content: () -> T
    ) {
        self.name = name
        body = content()
    }

    // MARK: - File

    public let name: String

    public let body: T

}
