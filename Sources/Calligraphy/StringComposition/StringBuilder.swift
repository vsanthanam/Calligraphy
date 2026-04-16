// Calligraphy
// StringBuilder.swift
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

/// A result builder to declaratively compose complex, multi-line strings
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum StringBuilder {

    public static func buildExpression<T: StringComponent>(
        _ expression: T
    ) -> T {
        expression
    }

    public static func buildExpression(
        _ expression: some StringProtocol
    ) -> RawStringComponent {
        .init(expression)
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: some RawRepresentable<some StringProtocol>
    ) -> RawStringComponent {
        expression.rawValue
    }

    @StringBuilder
    public static func buildExpression<T: StringComponent>(
        _ expression: [T]
    ) -> _List<T> {
        for item in expression {
            item
        }
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: [some StringProtocol]
    ) -> _List<RawStringComponent> {
        for item in expression {
            item
        }
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: [some RawRepresentable<some StringProtocol>]
    ) -> _List<RawStringComponent> {
        for item in expression {
            item
        }
    }

    public static func buildBlock() -> _Skip {
        .init()
    }

    public static func buildBlock<T: StringComponent>(
        _ component: T
    ) -> T {
        component
    }

    public static func buildBlock<each Component>(
        _ components: repeat each Component
    ) -> _Block<repeat each Component> where repeat each Component: StringComponent {
        .init(components: repeat each components)
    }

    public static func buildEither<First: StringComponent, Second: StringComponent>(
        first component: First
    ) -> _Either<First, Second> {
        .first(component)
    }

    public static func buildEither<First: StringComponent, Second: StringComponent>(
        second component: Second
    ) -> _Either<First, Second> {
        .second(component)
    }

    @StringBuilder
    public static func buildOptional<T: StringComponent>(
        _ component: T?
    ) -> _Either<T, _Skip> {
        if let component {
            component
        } else {
            _Skip()
        }
    }

    public static func buildArray<T: StringComponent>(
        _ components: [T]
    ) -> _List<T> {
        .init(components)
    }

    public static func buildLimitedAvailability(
        _ component: some StringComponent
    ) -> AnyStringComponent {
        AnyStringComponent(erasing: component)
    }

    public struct _Block<each Component>: StringComponent where repeat each Component: StringComponent {

        // MARK: - StringComponent

        public var _content: String? {
            var result: String? = nil
            func append(_ component: some StringComponent) {
                guard let content = component._content else {
                    return
                }
                if let r = result {
                    result = r + StringEnvironment.activeSeparator + content
                } else {
                    result = content
                }
            }
            for component in repeat each components {
                append(component)
            }
            return result
        }

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        // MARK: - Private

        fileprivate init(components: repeat each Component) {
            self.components = (repeat (each components))
        }

        private let components: (repeat (each Component))

    }

    public enum _Either<First: StringComponent, Second: StringComponent>: StringComponent {

        // MARK: - API

        case first(First)
        case second(Second)

        // MARK: - StringComponent

        public var _content: String? {
            switch self {
            case let .first(component):
                component._content
            case let .second(component):
                component._content
            }
        }

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }
    }

    public struct _List<Element: StringComponent>: StringComponent {

        // MARK: - StringComponent

        public var _content: String? {
            list
                .reduce(nil) { prev, component in
                    guard let content = component._content else {
                        return prev
                    }
                    if let prev {
                        return prev + StringEnvironment.activeSeparator + content
                    } else {
                        return content
                    }
                }
        }

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        // MARK: - Private

        fileprivate init(_ list: [Element]) {
            self.list = list
        }

        private let list: [Element]

    }

    public struct _Skip: StringComponent {

        /// Create an empty string component
        public init() {}

        // MARK: - StringComponent

        public let _content: String? = nil

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

    }

}
