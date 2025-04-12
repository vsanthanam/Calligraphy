// Calligraphy
// DataComponent.swift
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

/// A data component
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DataComponent: Sendable {

    /// The type of data component representing the body of this data component.
    ///
    /// Typically, you do not need to explicitly spell out this type.
    /// Instead. implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol
    associatedtype Body: DataComponent = Never
    
    /// The data contained in the coponent
    ///
    /// If you implement the ``body`` property, you do not need to implement this property.
    var data: Data? { get }

    /// The data contained in the component
    ///
    /// If you implement the ``data`` property, you do not need to implement this property.
    @DataBuilder
    var body: Body { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: DataComponent {

    public var data: Data? {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataComponent where Body == Never {

    @available(*, unavailable)
    public var data: Data? {
        fatalError()
    }

    public var body: Never {
        fatalError("DataComponent \(Self.self) does not have a body. Do not invoke this property directly.")
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DataComponent {

    public var data: Data? {
        body.data
    }

}
