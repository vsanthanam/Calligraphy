// Calligraphy
// Group.swift
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

/// An entry point to the ``StringBuilder`` result builder.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, message: "Use Group instead")
public struct StringGroup<Body>: StringComponent where Body: StringComponent {

    // MARK: - Initializers

    /// Assemble string components together, declaratively
    /// - Parameter body: The components to assemble
    public init(
        @StringBuilder body: () -> Body
    ) {
        self.body = body()
    }

    // MARK: - StringComponent

    public let body: Body

}

/// An entry point to Calligraphy's result builders.
///
/// `Group` wraps the result of a builder block in a typed value that you can store, pass around, modify, and compose into other builders. The same type works inside every Calligraphy builder: in a `@StringBuilder` the body closure is itself a `@StringBuilder`, in a `@DataBuilder` it is a `@DataBuilder`, and in a `@DirectoryBuilder` it is a `@DirectoryBuilder`.
///
/// @Snippet(path: "Calligraphy/Snippets/ComposingStrings/ComponentSeparators", slice: "joined")
///
/// Inside a string, `Group` is transparent to layout, like ``ForEach``: its children are joined using the surrounding ``EnvironmentValues/separator``, so inside ``Lines`` each child starts on a new line and inside ``Line`` the children are concatenated. Inside data, the children's bytes are concatenated. Inside a directory, the children's files and folders are listed in order.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Group<Body> {

    // MARK: - API

    /// The grouped content.
    public let body: Body

    // MARK: - Private

    private init(
        body: Body
    ) {
        self.body = body
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Group: StringComponent where Body: StringComponent {

    /// Group string components.
    /// - Parameter body: The string components to group.
    public init(
        @StringBuilder body: () -> Body
    ) {
        self.init(body: body())
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Group: DataComponent where Body: DataComponent {

    /// Group data components.
    /// - Parameter body: The data components to group.
    @_disfavoredOverload
    public init(
        @DataBuilder body: () -> Body
    ) {
        self.init(body: body())
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Group: DirectoryContent where Body: DirectoryContent {

    /// Group directory content.
    /// - Parameter body: The files and folders to group.
    @_disfavoredOverload
    public init(
        @DirectoryBuilder body: () -> Body
    ) {
        self.init(body: body())
    }

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        body._serialize(in: environment)
    }

}
