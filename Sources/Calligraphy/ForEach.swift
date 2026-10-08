// Calligraphy
// ForEach.swift
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

/// A component that produces content for every element of a collection.
///
/// Use `ForEach` to repeat content for each element in a collection, the way you would use `ForEach` in SwiftUI. The same type works inside every Calligraphy builder: in a `@StringBuilder` the `content` closure is itself a `@StringBuilder`, in a `@DataBuilder` it is a `@DataBuilder`, and in a `@DirectoryBuilder` it is a `@DirectoryBuilder`, so the full DSL is available when describing each element's contribution, including conditionals and modifiers:
///
/// @Snippet(path: "Calligraphy/Snippets/ForEach/RepeatingContent", slice: "for-each")
///
/// The same pattern repeats files and folders:
///
/// @Snippet(path: "Calligraphy/Snippets/ForEach/RepeatingFiles", slice: "files")
///
/// Inside a string, `ForEach` is transparent to layout, like ``StringGroup``: the results are joined using the surrounding ``EnvironmentValues/separator``, so inside ``Lines`` each element starts on a new line and inside ``Line`` the elements are concatenated. Inside data, the elements' bytes are concatenated. Inside a directory, the elements' files and folders are listed in order. Elements whose content renders nothing are skipped.
///
/// Calligraphy's builders do not accept `for`-`in` loops; `ForEach` fills that role, and unlike a loop it can contain expressions whose type is opaque, such as the result of a modifier.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct ForEach<Data, Content> where Data: Collection {

    // MARK: - API

    /// `ForEach` has no body. It renders its elements directly.
    public var body: Never {
        fatalError(
            """
            ForEach does not have a body. Do not invoke this property directly.
            """
        )
    }

    // MARK: - Private

    private init(
        data: Data,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
    }

    private let data: Data
    private let content: (Data.Element) -> Content

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension ForEach: StringComponent where Content: StringComponent {

    /// Create a string component that produces content for every element of a collection.
    ///
    /// - Parameters:
    ///   - data: The collection to iterate over.
    ///   - content: A `@StringBuilder` closure that produces the content for a single element.
    public init(
        _ data: Data,
        @StringBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data: data, content: content)
    }

    public func _render(
        in environment: EnvironmentValues
    ) -> String? {
        let pieces = data
            .map { element in
                content(element)._render(in: environment)
            }
        return environment.draw(with: pieces)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension ForEach: DataComponent where Content: DataComponent {

    /// Create a data component that produces content for every element of a collection.
    ///
    /// - Parameters:
    ///   - data: The collection to iterate over.
    ///   - content: A `@DataBuilder` closure that produces the content for a single element.
    public init(
        _ data: Data,
        @DataBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data: data, content: content)
    }

    public func _render(
        in environment: EnvironmentValues
    ) -> Foundation.Data? {
        data
            .reduce(nil) { result, element in
                guard let piece = content(element)._render(in: environment) else {
                    return result
                }
                if let result {
                    return result + piece
                } else {
                    return piece
                }
            }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension ForEach: DirectoryContent where Content: DirectoryContent {

    /// Create directory content that produces files and folders for every element of a collection.
    ///
    /// - Parameters:
    ///   - data: The collection to iterate over.
    ///   - content: A `@DirectoryBuilder` closure that produces the content for a single element.
    public init(
        _ data: Data,
        @DirectoryBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data: data, content: content)
    }

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        data
            .flatMap { element in
                content(element)._serialize(in: environment)
            }
    }

}
