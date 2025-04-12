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

/// A result builder for directory content
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum DirectoryContentBuilder {

    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: DirectoryComponent {
        expression
    }

    public static func buildExpression(
        _ expression: [SerializedDirectoryContent]
    ) -> _AlreadySerialized {
        .init(expression)
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
        _ expression: SerializedDirectoryContent.Directory
    ) -> _AlreadySerialized {
        .directory(expression)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: [SerializedDirectoryContent.File]
    ) -> _AlreadySerialized {
        expression
            .map(SerializedDirectoryContent.file)
    }

    @DirectoryContentBuilder
    public static func buildExpression(
        _ expression: [SerializedDirectoryContent.Directory]
    ) -> _AlreadySerialized {
        expression
            .map(SerializedDirectoryContent.directory)
    }

    public static func buildBlock() -> EmptyDirectoryComponent {
        EmptyDirectoryComponent()
    }

    public static func buildBlock<T>(
        _ component: T
    ) -> T where T: DirectoryComponent {
        component
    }

    public static func buildBlock<each Component>(
        _ components: repeat each Component
    ) -> _Block<repeat each Component> where repeat each Component: DirectoryComponent {
        .init(components: repeat each components)
    }

    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> where First: DirectoryComponent, Second: DirectoryComponent {
        .first(component)
    }

    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> where First: DirectoryComponent, Second: DirectoryComponent {
        .second(component)
    }

    @DirectoryContentBuilder
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, EmptyDirectoryComponent> where T: DirectoryComponent {
        if let component {
            component
        } else {
            EmptyDirectoryComponent()
        }
    }

    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: DirectoryComponent {
        .init(components)
    }

    public struct _AlreadySerialized: DirectoryComponent {

        // MARK: - DirectoryComponent

        public func _serialize() -> [SerializedDirectoryContent] {
            content
        }

        // MARK: - Private

        fileprivate init(
            _ content: [SerializedDirectoryContent]
        ) {
            self.content = content
        }

        private let content: [SerializedDirectoryContent]

    }

    public struct _Block<each Component>: DirectoryComponent where repeat each Component: DirectoryComponent {

        // MARK: - DirectoryComponent

        public func _serialize() -> [SerializedDirectoryContent] {
            var result = [SerializedDirectoryContent]()
            for component in repeat each components {
                result += component._serialize()
            }
            return result
        }

        // MARK: - Private

        fileprivate init(
            components: repeat each Component
        ) {
            self.components = (repeat (each components))
        }

        private let components: (repeat (each Component))

    }

    public enum _Either<First, Second>: DirectoryComponent where First: DirectoryComponent, Second: DirectoryComponent {

        // MARK: - API

        case first(First)

        case second(Second)

        // MARK: - DirectoryComponent

        public func _serialize() -> [SerializedDirectoryContent] {
            switch self {
            case let .first(component):
                component._serialize()
            case let .second(component):
                component._serialize()
            }
        }
    }

    public struct _List<Element>: DirectoryComponent where Element: DirectoryComponent {

        // MARK: - DirectoryComponent

        public func _serialize() -> [SerializedDirectoryContent] {
            list
                .flatMap { component in
                    component._serialize()
                }
        }

        // MARK: - Private

        fileprivate init(
            _ list: [Element]
        ) {
            self.list = list
        }

        private let list: [Element]

    }
}
