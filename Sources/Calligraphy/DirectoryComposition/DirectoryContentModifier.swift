// Calligraphy
// DirectoryContentModifier.swift
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

/// A modifier that you apply to directory content, producing a different version of the original content.
///
/// Adopt `DirectoryContentModifier` to package a reusable transformation of files and folders, the same way you adopt ``StringModifier`` for strings. Implement ``body(content:)`` to describe the result, using `content` as a placeholder for whichever content the modifier is eventually applied to:
///
/// @Snippet(path: "Calligraphy/Snippets/DirectoryContentModifier/CustomDirectoryContentModifier", slice: "modifier")
///
/// Apply a modifier with ``DirectoryContent/modifier(_:)``. To make a modifier read like the built-in ones, wrap that call in an extension on ``DirectoryContent``:
///
/// @Snippet(path: "Calligraphy/Snippets/DirectoryContentModifier/CustomDirectoryContentModifier", slice: "extension")
///
/// A modifier can read the surrounding environment with the ``Environment`` property wrapper, just like a ``Directory`` can.
///
/// Most modifiers only need ``body(content:)``. A modifier that must work with the serialized files and folders themselves, or serialize the content in a different environment, can instead implement ``serialize(content:in:)`` and declare `Never` as its ``Body``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DirectoryContentModifier {

    /// The type of directory content produced by this modifier.
    ///
    /// Typically, you do not need to explicitly spell out this type. Instead, implement ``body(content:)`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
    associatedtype Body: DirectoryContent

    /// The type of the content passed to ``body(content:)``.
    ///
    /// This type is a placeholder for the content the modifier is applied to. You never create a value of this type yourself; one is supplied each time the modifier is applied.
    typealias Content = _DirectoryContentModifier_Content<Self>

    /// Describe the content produced by applying this modifier.
    ///
    /// - Parameter content: A placeholder for the content the modifier is applied to.
    /// - Returns: The modified content.
    @DirectoryBuilder
    func body(content: Self.Content) -> Body

    /// Serialize the modified content using the supplied environment.
    ///
    /// The default implementation serializes ``body(content:)``. Implement this method directly, and declare `Never` as the ``Body``, when the modifier needs the serialized files and folders of its content or must serialize the content in a different environment. Any ``Environment`` properties on the modifier are resolved before this method is called.
    ///
    /// - Parameters:
    ///   - content: A placeholder for the content the modifier is applied to.
    ///   - environment: The environment values to read during serialization.
    /// - Returns: The serialized files and directories represented by the modified content.
    func serialize(
        content: Self.Content,
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent]

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DirectoryContentModifier {

    public func serialize(
        content: Self.Content,
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        body(content: content)
            ._serialize(in: environment)
    }

    func fatalErrorImperativeDirectoryContentModifier(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError(
            """
            DirectoryContentModifier \(Self.self) does not have a body. Do not invoke this method directly.
            """,
            file: file,
            line: line
        )
    }

}

/// A placeholder for the content a ``DirectoryContentModifier`` is applied to.
///
/// You never create this type directly. ``ModifiedDirectoryContent`` creates it and passes it to ``DirectoryContentModifier/body(content:)``, where you refer to it as ``DirectoryContentModifier/Content`` and compose around it as you would any other content. When serialized, the placeholder serializes the original content in whatever environment the modifier's body provides.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct _DirectoryContentModifier_Content<Modifier>: DirectoryContent where Modifier: DirectoryContentModifier {

    // MARK: - Initializers

    init<Content>(
        erasing content: Content
    ) where Content: DirectoryContent {
        self.content = AnyDirectoryContent(erasing: content)
    }

    // MARK: - DirectoryContent

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        content._serialize(in: environment)
    }

    // MARK: - Private

    private let content: AnyDirectoryContent

}
