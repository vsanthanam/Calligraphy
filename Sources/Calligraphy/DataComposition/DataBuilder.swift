// Calligraphy
// DataBuilder.swift
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

import Foundation

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum DataBuilder {

    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: DataComponent {
        expression
    }

    public static func buildExpression(
        _ expression: Data
    ) -> RawDataComponent {
        .init(expression)
    }

    @DataBuilder
    public static func buildExpression(
        _ expression: [UInt8]
    ) -> RawDataComponent {
        Data(expression)
    }

    @DataBuilder
    public static func buildExpression(
        _ expression: UInt8
    ) -> RawDataComponent {
        [expression]
    }

    @DataBuilder
    public static func buildExpression(
        _ expression: some Collection<Data>
    ) -> RawDataComponent {
        expression.reduce(Data(), +)
    }

    @DataBuilder
    public static func buildExpression(
        _ expression: some Collection<UInt8>
    ) -> RawDataComponent {
        Array(expression)
    }

    public static func buildBlock() -> EmptyDataComponent {
        EmptyDataComponent()
    }

    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: DataComponent {
        first
    }

    public static func buildPartialBlock<each Accumulated, Next>(
        accumulated: repeat each Accumulated,
        next: Next
    ) -> _Accumulate<repeat each Accumulated, Next> where repeat each Accumulated: DataComponent, Next: DataComponent {
        .init(
            accumulated: repeat each accumulated,
            next: next
        )
    }

    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> where First: DataComponent, Second: DataComponent {
        .first(component)
    }

    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> {
        .second(component)
    }

    @DataBuilder
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, EmptyDataComponent> where T: DataComponent {
        if let component {
            component
        } else {
            EmptyDataComponent()
        }
    }

    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: DataComponent {
        .init(components)
    }

    public static func buildLimitedAvailability(
        _ component: some DataComponent
    ) -> AnyDataComponent {
        AnyDataComponent(component)
    }

    public struct _Accumulate<each Accumulated, Next>: DataComponent where repeat each Accumulated: DataComponent, Next: DataComponent {

        // MARK: - DataComponent

        public var data: Data? {
            var result: Data? = nil
            func append(_ component: some DataComponent) {
                guard let data = component.data else {
                    return
                }
                if let r = result {
                    result = r + data
                } else {
                    result = data
                }
            }
            for component in repeat each accumulated {
                append(component)
            }
            append(next)
            return result
        }

        // MARK: - Private

        fileprivate init(
            accumulated: repeat each Accumulated,
            next: Next
        ) {
            self.accumulated = (repeat (each accumulated))
            self.next = next
        }

        private let accumulated: (repeat (each Accumulated))
        private let next: Next

    }

    public enum _Either<First, Second>: DataComponent where First: DataComponent, Second: DataComponent {

        // MARK: - API

        case first(First)
        case second(Second)

        // MARK: - DataComponent

        public var data: Data? {
            switch self {
            case let .first(component):
                component.data
            case let .second(component):
                component.data
            }
        }

    }

    public struct _List<Element>: DataComponent where Element: DataComponent {

        // MARK: - DataComponent

        public var data: Data? {
            list
                .reduce(nil) { prev, component in
                    guard let data = component.data else {
                        return prev
                    }
                    if let prev {
                        return prev + data
                    } else {
                        return data
                    }
                }
        }

        // MARK: - Private

        fileprivate init(_ list: [Element]) {
            self.list = list
        }

        private let list: [Element]

    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (_ lhs: some DataComponent, _ rhs: some DataComponent) -> some DataComponent {
    lhs
    rhs
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (_ lhs: some DataComponent, _ rhs: Data) -> some DataComponent {
    lhs
    rhs
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (_ lhs: Data, _ rhs: some DataComponent) -> some DataComponent {
    lhs
    rhs
}
