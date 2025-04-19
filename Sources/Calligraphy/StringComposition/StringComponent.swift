// Calligraphy
// StringComponent.swift
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

/// A component of a declaratively composed string
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol StringComponent: Sendable {

    /// The type of string component representing the body of this string component.
    ///
    /// Typically, you do not need to explicitly spell out this type.
    /// Instead. implement ``body`` using an opaque `some StringComponent` type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol
    associatedtype Body: StringComponent

    /// The string this component represents
    var _content: String? { get }

    /// The sub components used to build this string component.
    @StringBuilder
    var body: Body { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: StringComponent {

    public var _content: String? {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    public var _content: String? {
        body._content
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    func fatalErrorPrivateStringComponent(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError("StringComponent \(Self.self) does not have a body. Do not invoke this property directly.", file: file, line: line)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@StringBuilder
public func + (_ lhs: some StringComponent, _ rhs: some StringComponent) -> some StringComponent {
    if let lhs = lhs._content, let rhs = rhs._content {
        lhs + rhs
    } else if let lhs = lhs._content {
        lhs + rhs
    } else if let rhs = rhs._content {
        lhs + rhs
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@StringBuilder
public func + (_ lhs: some StringComponent, _ rhs: some StringProtocol) -> some StringComponent {
    if let lhs = lhs._content {
        lhs + String(rhs)
    } else {
        rhs
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@StringBuilder
public func + (_ lhs: some StringProtocol, _ rhs: some StringComponent) -> some StringComponent {
    if let rhs = rhs._content {
        String(lhs) + rhs
    } else {
        lhs
    }
}
