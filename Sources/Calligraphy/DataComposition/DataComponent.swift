// Calligraphy
// DataComponent.swift
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

import Foundation

/// A type that contributes to the construction of binary data.
///
/// A `DataComponent` is a declarative representation of a sequence of bytes.
/// By composing components together inside a ``DataBuilder``, you build up a final `Data` value the same way you would build a `String` with ``StringComponent``.
///
/// Implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
/// A data component can read the surrounding environment with the ``Environment`` property wrapper.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@_typeEraser(AnyDataComponent)
public protocol DataComponent {

    /// The type of data component representing the body of this data component.
    ///
    /// Typically, you do not need to explicitly spell out this type.
    /// Instead. implement body using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol
    associatedtype Body: DataComponent

    /// The sub components used to build this data component.
    @DataBuilder
    var body: Body { get }

    /// Render this component into `Data` using the supplied environment.
    ///
    /// You rarely need to call this method directly. Instead, convert a component to `Data` using `Data.init(_:)`, which evaluates the component in a fresh environment.
    ///
    /// - Parameter environment: The environment values to read during rendering.
    /// - Returns: The rendered data, or `nil` if the component contributes nothing.
    func _render(
        in environment: borrowing EnvironmentValues
    ) -> Data?

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: DataComponent {

    public func _render(
        in environment: borrowing EnvironmentValues
    ) -> Data? {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataComponent {

    public func _render(
        in environment: borrowing EnvironmentValues
    ) -> Data? {
        environment.inject(into: self)
        return body._render(in: environment)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataComponent {

    func fatalErrorImperativeDataComponent(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError(
            """
            DataComponent \(Self.self) does not have a body. Do not invoke this property directly.
            """,
            file: file,
            line: line
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (
    _ lhs: consuming some DataComponent,
    _ rhs: consuming some DataComponent
) -> some DataComponent {
    lhs
    rhs
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (
    _ lhs: consuming some DataComponent,
    _ rhs: consuming Data
) -> some DataComponent {
    lhs
    rhs
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@DataBuilder
public func + (
    _ lhs: consuming Data,
    _ rhs: consuming some DataComponent
) -> some DataComponent {
    lhs
    rhs
}
