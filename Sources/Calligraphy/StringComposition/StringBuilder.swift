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

/// A result builder to declaratively compose ``StringComponent`` values together.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum StringBuilder {

    public static func buildExpression<Expression>(
        _ expression: Expression
    ) -> Expression where Expression: StringComponent {
        expression
    }

    public static func buildExpression<Expression>(
        _ expression: Expression
    ) -> RawStringComponent where Expression: StringProtocol {
        RawStringComponent(expression)
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: some RawRepresentable<some StringProtocol>
    ) -> RawStringComponent {
        expression.rawValue
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: some Collection<some StringComponent>
    ) -> some StringComponent {
        for element in expression {
            element
        }
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: some Collection<some StringProtocol>
    ) -> some StringComponent {
        for element in expression {
            element
        }
    }

    @StringBuilder
    public static func buildExpression(
        _ expression: some Collection<some RawRepresentable<some StringProtocol>>
    ) -> some StringComponent {
        for element in expression {
            element
        }
    }

    public static func buildBlock() -> _Skip {
        .init()
    }

    public static func buildBlock<Component>(
        _ components: Component
    ) -> Component where Component: StringComponent {
        components
    }

    public static func buildBlock<each Component>(
        _ components: repeat each Component
    ) -> _Assembled<repeat each Component> where repeat each Component: StringComponent {
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
    public static func buildOptional<Component>(
        _ component: Component?
    ) -> _Either<Component, _Skip> where Component: StringComponent {
        if let component {
            component
        } else {
            _Skip()
        }
    }

    public static func buildArray<Component>(
        _ components: [Component]
    ) -> _List<Component> where Component: StringComponent {
        .init(components)
    }

    public static func buildLimitedAvailability<Component>(
        _ component: Component
    ) -> AnyStringComponent where Component: StringComponent {
        .init(erasing: component)
    }

    public static func buildFinalResult<Component>(
        _ component: Component
    ) -> Component where Component: StringComponent {
        component
    }

    @_disfavoredOverload
    public static func buildFinalResult(
        _ component: some StringComponent
    ) -> String {
        String(component)
    }

    public struct _Assembled<each Component>: StringComponent where repeat each Component: StringComponent {

        // MARK: - StringComponent

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        public func render(
            in environment: StringEnvironmentValues
        ) -> String? {
            var pieces = [String?]()
            for component in repeat each components {
                pieces.append(component.render(in: environment))
            }
            return environment.draw(with: pieces)
        }

        // MARK: - Private

        fileprivate init(
            components: repeat each Component
        ) {
            self.components = (repeat each components)
        }

        private let components: (repeat each Component)

    }

    public enum _Either<First, Second>: StringComponent where First: StringComponent, Second: StringComponent {

        // MARK: - API

        case first(First)

        case second(Second)

        // MARK: - StringComponent

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        public func render(
            in environment: StringEnvironmentValues
        ) -> String? {
            switch self {
            case let .first(component):
                component.render(in: environment)
            case let .second(component):
                component.render(in: environment)
            }
        }

    }

    public struct _Skip: StringComponent {

        // MARK: - StringComponent

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        public func render(
            in environment: StringEnvironmentValues
        ) -> String? {
            nil
        }

        // MARK: - Private

        fileprivate init() {}

    }

    public struct _List<Element>: StringComponent where Element: StringComponent {

        // MARK: - StringComponent

        public var body: Never {
            fatalErrorImperativeStringComponent()
        }

        public func render(
            in environment: StringEnvironmentValues
        ) -> String? {
            let pieces = list
                .map { element in
                    element.render(in: environment)
                }
            return environment.draw(with: pieces)
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
