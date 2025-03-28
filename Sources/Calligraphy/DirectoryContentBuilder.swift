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
@available(macOS 15.0, macCatalyst 18.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
@resultBuilder
public enum DirectoryContentBuilder {

    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: DirectoryContent {
        expression
    }

    public static func buildExpression<T>() -> some DirectoryContent {
        Skip()
    }

    public static func buildExpression(
        _ expression: [SerializedDirectoryContent]
    ) -> some DirectoryContent {
        Raw(expression)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent
    ) -> some DirectoryContent {
        [expression]
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent.File
    ) -> some DirectoryContent {
        .file(expression)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: SerializedDirectoryContent.Directory
    ) -> some DirectoryContent {
        .directory(expression)
    }

    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: DirectoryContent {
        first
    }

    public static func buildPartialBlock<each Accumulated>(
        accumulated: repeat each Accumulated,
        next: some DirectoryContent
    ) -> some DirectoryContent where repeat each Accumulated: DirectoryContent {
        Accumulate(
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
    ) -> some DirectoryContent where T: DirectoryContent {
        if let component {
            component
        } else {
            Skip()
        }
    }

    public static func buildArray(
        _ components: [some DirectoryContent]
    ) -> some DirectoryContent {
        List(components)
    }

    public static func buildLimitedAvailability(
        _ component: some DirectoryContent
    ) -> AnyDirectoryContent {
        AnyDirectoryContent(component)
    }

    struct Accumulate<each Accumulated, Next>: DirectoryContent where repeat each Accumulated: DirectoryContent, Next: DirectoryContent {

        // MARK: - Initializers

        init(
            accumulated: repeat each Accumulated,
            next: Next
        ) {
            self.accumulated = (repeat (each accumulated))
            self.next = next
        }

        // MARK: - DirectoryContent

        func _serialize() -> [SerializedDirectoryContent] {
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

    struct Skip: DirectoryContent {

        // MARK: - Initializers

        init() {}

        // MARK: - DirectoryContent

        func _serialize() -> [SerializedDirectoryContent] {
            []
        }

    }

    struct List<Element>: DirectoryContent where Element: DirectoryContent {

        // MARK: - Initializers

        init(_ list: [Element]) {
            self.list = list
        }

        // MARK: - DirectoryContent

        func _serialize() -> [SerializedDirectoryContent] {
            list.flatMap { $0._serialize() }
        }

        // MARK: - Private

        private let list: [Element]

    }

    struct Raw: DirectoryContent {

        // MARK: - Initializers

        init(_ contents: [SerializedDirectoryContent]) {
            self.contents = contents
        }

        // MARK: - DirectoryContent

        func _serialize() -> [SerializedDirectoryContent] {
            contents
        }

        // MARK: - Private

        private let contents: [SerializedDirectoryContent]

    }

}
