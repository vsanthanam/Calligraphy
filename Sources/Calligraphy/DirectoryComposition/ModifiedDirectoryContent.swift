// Calligraphy
// ModifiedDirectoryContent.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DirectoryContent {

    /// Apply a ``DirectoryContentModifier`` to this content.
    ///
    /// Use this method to apply a custom modifier, or wrap it in an extension on ``DirectoryContent`` so the modifier reads like a built-in one:
    ///
    /// @Snippet(path: "Calligraphy/Snippets/DirectoryContentModifier/CustomDirectoryContentModifier", slice: "extension")
    ///
    /// - Parameter modifier: The modifier to apply.
    /// - Returns: This content with the modifier applied.
    public func modifier<Modifier>(
        _ modifier: consuming Modifier
    ) -> ModifiedDirectoryContent<Self, Modifier> where Modifier: DirectoryContentModifier {
        ModifiedDirectoryContent(
            content: self,
            modifier: modifier
        )
    }

}

/// ``Directory`` content with a ``DirectoryContentModifier`` applied to it.
///
/// You rarely create this type directly. It is the return type of ``DirectoryContent/modifier(_:)``, which pairs content with a modifier. When the pair is serialized, the modifier's ``DirectoryContentModifier/body(content:)`` is expanded with a placeholder standing in for `content`, and the result is serialized in the current environment. Any ``Environment`` properties declared by the modifier are resolved first, so a modifier can read the environment just like a ``Directory`` can.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct ModifiedDirectoryContent<Content, Modifier>: DirectoryContent where Content: DirectoryContent, Modifier: DirectoryContentModifier {

    // MARK: - Initializers

    /// Create directory content with a modifier applied to it.
    ///
    /// Prefer ``DirectoryContent/modifier(_:)`` over calling this initializer directly.
    ///
    /// - Parameters:
    ///   - content: The content to modify.
    ///   - modifier: The modifier to apply.
    public init(
        content: Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }

    // MARK: - DirectoryContent

    public func _serialize(
        in environment: borrowing EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        environment.inject(into: modifier)
        return modifier
            .serialize(
                content: .init(erasing: content),
                in: environment
            )
    }

    // MARK: - Private

    private let content: Content
    private let modifier: Modifier

}
