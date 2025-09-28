// Calligraphy
// StringBuilder.swift
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

/// A result builder to declaratively compose complex, multi-line strings
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum StringBuilder {

    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: StringComponent {
        expression
    }

    public static func buildExpression(
        _ expression: some StringProtocol
    ) -> RawStringComponent {
        .init(expression)
    }

    @StringBuilder
    public static func buildExpression<T>(
        _ expression: T
    ) -> RawStringComponent where T: RawRepresentable, T.RawValue: StringProtocol {
        expression.rawValue
    }

    public static func buildBlock() -> _Skip {
        .init()
    }

    public static func buildBlock<T>(
        _ component: T
    ) -> T where T: StringComponent {
        component
    }

    public static func buildBlock<each Component>(
        _ components: repeat each Component
    ) -> _Block<repeat each Component> where repeat each Component: StringComponent {
        .init(components: repeat each components)
    }

    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> where First: StringComponent, Second: StringComponent {
        .first(component)
    }

    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> where First: StringComponent, Second: StringComponent {
        .second(component)
    }

    @StringBuilder
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, _Skip> where T: StringComponent {
        if let component {
            component
        } else {
            _Skip()
        }
    }

    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: StringComponent {
        .init(components)
    }

    public static func buildLimitedAvailability(
        _ component: some StringComponent
    ) -> AnyStringComponent {
        AnyStringComponent(component)
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

    public enum _Either<First, Second>: StringComponent where First: StringComponent, Second: StringComponent {

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

    public struct _List<Element>: StringComponent where Element: StringComponent {

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
