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

/// A result builder to declaratively compose `Data` values together
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

    public static func buildBlock<T>(
        _ component: T
    ) -> T where T: DataComponent {
        component
    }

    public static func buildBlock<each Component>(
        _ components: repeat each Component
    ) -> _Block<repeat each Component> where repeat each Component: DataComponent {
        .init(components: repeat each components)
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

    public struct _Block<each Component>: DataComponent where repeat each Component: DataComponent {

        // MARK: - DataComponent

        public var _data: Data? {
            var result: Data? = nil
            func append(_ component: some DataComponent) {
                guard let data = component._data else {
                    return
                }
                if let r = result {
                    result = r + data
                } else {
                    result = data
                }
            }
            for component in repeat each components {
                append(component)
            }
            return result
        }

        public var body: Never {
            fatalErrorPrivateDataComponent()
        }

        // MARK: - Private

        fileprivate init(components: repeat each Component) {
            self.components = (repeat (each components))
        }

        private let components: (repeat (each Component))

    }

    public enum _Either<First, Second>: DataComponent where First: DataComponent, Second: DataComponent {

        // MARK: - API

        case first(First)
        case second(Second)

        // MARK: - DataComponent

        public var _data: Data? {
            switch self {
            case let .first(component):
                component._data
            case let .second(component):
                component._data
            }
        }

        public var body: Never {
            fatalErrorPrivateDataComponent()
        }

    }

    public struct _List<Element>: DataComponent where Element: DataComponent {

        // MARK: - DataComponent

        public var _data: Data? {
            list
                .reduce(nil) { prev, component in
                    guard let data = component._data else {
                        return prev
                    }
                    if let prev {
                        return prev + data
                    } else {
                        return data
                    }
                }
        }

        public var body: Never {
            fatalErrorPrivateDataComponent()
        }

        // MARK: - Private

        fileprivate init(_ list: [Element]) {
            self.list = list
        }

        private let list: [Element]

    }
}
