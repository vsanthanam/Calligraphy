// Calligraphy
// DirectoryContentBuilder.swift
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

/// A result build for directory content
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum DirectoryContentBuilder {

    // MARK: - Result Builder

    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: DirectoryContent {
        expression
    }

    public static func buildExpression(
        _ expression: [SerializedDirectoryContent]
    ) -> _AlreadySerialized {
        _AlreadySerialized(expression)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent
    ) -> _AlreadySerialized {
        [expression]
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent.File
    ) -> _AlreadySerialized {
        .file(expression)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: [SerializedDirectoryContent.File]
    ) -> _List<_AlreadySerialized> {
        for file in expression {
            file
        }
    }
    
    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent.Directory
    ) -> _AlreadySerialized {
        .directory(expression)
    }
    
    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: [SerializedDirectoryContent.Directory]
    ) -> _List<_AlreadySerialized> {
        for directory in expression {
            directory
        }
    }

    public static func buildBlock() -> EmptyDirectoryContent {
        EmptyDirectoryContent()
    }

    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: DirectoryContent {
        first
    }

    public static func buildPartialBlock<each Accumulated, Next>(
        accumulated: repeat each Accumulated,
        next: Next
    ) -> _Accumulate<repeat each Accumulated, Next> where repeat each Accumulated: DirectoryContent, Next: DirectoryContent {
        _Accumulate(
            accumulated: repeat each accumulated,
            next: next
        )
    }

    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> where First: DirectoryContent, Second: DirectoryContent {
        .first(component)
    }

    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> where First: DirectoryContent, Second: DirectoryContent {
        .second(component)
    }

    @DirectoryContentBuilder
    public static func buildOptional<T>(
        component: T?
    ) -> _Either<T, EmptyDirectoryContent> where T: DirectoryContent {
        if let component {
            component
        } else {
            EmptyDirectoryContent()
        }
    }

    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: DirectoryContent {
        _List(components)
    }

    public static func buildLimitedAvailability(
        _ component: some DirectoryContent
    ) -> AnyDirectoryContent {
        AnyDirectoryContent(component)
    }

    // MARK: - API

    public enum _Either<First, Second>: DirectoryContent where First: DirectoryContent, Second: DirectoryContent {

        // MARK: - API

        case first(First)

        case second(Second)

        // MARK: - DirectoryContent

        public func _serialize() -> [SerializedDirectoryContent] {
            switch self {
            case let .first(content):
                content._serialize()
            case let .second(content):
                content._serialize()
            }
        }

    }

    // MARK: - Private

    public struct _Accumulate<each Accumulated, Next>: DirectoryContent where repeat each Accumulated: DirectoryContent, Next: DirectoryContent {

        // MARK: - Initializers

        init(
            accumulated: repeat each Accumulated,
            next: Next
        ) {
            self.accumulated = (repeat (each accumulated))
            self.next = next
        }

        // MARK: - DirectoryContent

        public func _serialize() -> [SerializedDirectoryContent] {
            var rv = [SerializedDirectoryContent]()
            for content in repeat each accumulated {
                rv += content._serialize()
            }
            rv += next._serialize()
            return rv
        }

        // MARK: - Private

        private let accumulated: (repeat (each Accumulated))
        private let next: Next

    }

    public struct _List<Element>: DirectoryContent where Element: DirectoryContent {

        // MARK: - Initializers

        init(_ list: [Element]) {
            self.list = list
        }

        // MARK: - DirectoryContent

        public func _serialize() -> [SerializedDirectoryContent] {
            list.flatMap { $0._serialize() }
        }

        // MARK: - Private

        private let list: [Element]

    }

    public struct _AlreadySerialized: DirectoryContent {

        // MARK: - Initializers

        init(_ contents: [SerializedDirectoryContent]) {
            self.contents = contents
        }

        // MARK: - DirectoryContent

        public func _serialize() -> [SerializedDirectoryContent] {
            contents
        }

        // MARK: - Private

        private let contents: [SerializedDirectoryContent]

    }

}
