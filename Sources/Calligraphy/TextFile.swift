// Calligraphy
// TextFile.swift
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

/// A type representing a file
///
/// You can implement `TextFile` either declaratively, by implemeting the ``body`` property, or declaratively, by implementing the ``content`` property.
/// Do not implement both. If you do, the `content` property will be respected and the `body` property would be ignored.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol TextFile: DataFile {

    /// The type of the declarative content of the file
    associatedtype Body: Stroke = Never

    /// The content of the file
    var content: String { get }

    /// The declarative content of the file
    @Calligraphy
    var body: Body { get }

    /// The string encoding of the file
    var encoding: String.Encoding { get }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension TextFile {

    var encoding: String.Encoding { .utf8 }

    var data: Data { content.data(using: encoding)! }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension TextFile where Body: Stroke {

    var content: String {
        String(stroke: body)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension TextFile where Body == Never {

    @available(*, unavailable)
    var content: String {
        fatalError()
    }

    var body: Never {
        fatalError("TextFile \(Self.self) does not have a body. Do not invoke this property directly.")
    }

}
