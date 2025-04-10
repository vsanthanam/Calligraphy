// Calligraphy
// Calligraphy.swift
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

/// A result builder for Swift strings
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum Calligraphy {

    // MARK: - Result Builder

    /// Support for ``Stroke`` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: Stroke {
        expression
    }

    /// Support for `String` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildExpression(
        _ expression: String
    ) -> StringStroke {
        StringStroke(expression)
    }

    /// Support for `StringProtocol` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    @Calligraphy
    public static func buildExpression(
        _ expression: some StringProtocol
    ) -> StringStroke {
        String(expression)
    }

    /// Support for `CustomStringConvertible` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    @Calligraphy
    public static func buildExpression(
        _ expression: some CustomStringConvertible
    ) -> StringStroke {
        expression.description
    }

    /// Support for `RawRepresentable` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    @Calligraphy
    public static func buildExpression<T>(
        _ expression: T
    ) -> StringStroke where T: RawRepresentable, T.RawValue: StringProtocol {
        expression.rawValue
    }

    /// Support for `Void` expressions in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildBlock() -> EmptyStroke {
        EmptyStroke()
    }

    /// Support for aggregating strokes together in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: Stroke {
        first
    }

    /// Support for aggregating strokes together in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildPartialBlock<each Accumulated, Next>(
        accumulated: repeat each Accumulated,
        next: Next
    ) -> _Accumulate<repeat each Accumulated, Next> where repeat each Accumulated: Stroke, Next: Stroke {
        _Accumulate(accumulated: repeat each accumulated, next: next)
    }

    /// Support for if-else control flow and switch statements in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> where First: Stroke, Second: Stroke {
        .first(component)
    }

    /// Support for if-else control flow and switch statements in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> where First: Stroke, Second: Stroke {
        .second(component)
    }

    /// Support for if statement control flow in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    @Calligraphy
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, EmptyStroke> where T: Stroke {
        if let component {
            component
        } else {
            EmptyStroke()
        }
    }

    /// Support for a for-in loops in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation detail of the result builder.
    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: Stroke {
        _List(components)
    }

    /// Support for availability checks in a `Calligraphy` result builder.
    /// - Important: You are not supposed to invoke this method directly. It is an implementation of the result builder.
    public static func buildLimitedAvailability(
        _ component: some Stroke
    ) -> AnyStroke {
        AnyStroke(component)
    }

    // MARK: - API

    public enum _Either<First, Second>: Stroke where First: Stroke, Second: Stroke {

        // MARK: - API

        case first(First)

        case second(Second)

        // MARK: - Stroke

        public var content: String? {
            switch self {
            case let .first(stroke):
                stroke.content
            case let .second(stroke):
                stroke.content
            }
        }

    }

    public struct _Accumulate<each Accumulated, Next>: Stroke where repeat each Accumulated: Stroke, Next: Stroke {

        // MARK: - Initializers

        init(
            accumulated: repeat each Accumulated,
            next: Next
        ) {
            self.accumulated = (repeat (each accumulated))
            self.next = next
        }

        // MARK: - Stroke

        public var content: String? {
            var result: String? = nil
            func append(_ content: String?) {
                guard let content else {
                    return
                }
                if let r = result {
                    result = r + Calligraphy.separator + content
                } else {
                    result = content
                }
            }
            for str in repeat each accumulated {
                append(str.content)
            }
            append(next.content)
            return result
        }

        // MARK: - Private

        private let accumulated: (repeat (each Accumulated))
        private let next: Next

    }

    public struct _List<Element>: Stroke where Element: Stroke {

        // MARK: - Initializers

        init(_ list: [Element]) {
            self.list = list
        }

        // MARK: - Stroke

        public var content: String? {
            list
                .reduce(nil) { prev, stroke in
                    guard let content = stroke.content else {
                        return prev
                    }
                    if let prev {
                        return prev + Calligraphy.separator + content
                    } else {
                        return content
                    }
                }
        }

        // MARK: - Private

        private let list: [Element]
    }

    @TaskLocal
    static var separator: String = "\n"
}
