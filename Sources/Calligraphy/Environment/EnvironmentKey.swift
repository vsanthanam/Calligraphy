// Calligraphy
// EnvironmentKey.swift
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

/// A key for reading and writing a value in ``EnvironmentValues``.
///
/// You rarely conform to this protocol by hand. Instead, apply the ``Entry()`` macro to a stored property in an extension on ``EnvironmentValues``, which synthesizes a private key type for you. Conform to `EnvironmentKey` directly when you want to use the key type itself with ``Environment/init(_:)-(Key.Type)`` or ``StringComponent/environment(_:_:)-(Key.Type,_)``.
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentKey", slice: "key")
///
/// Read the value with ``Environment/init(_:)-(Key.Type)`` and set it with ``StringComponent/environment(_:_:)-(Key.Type,_)``:
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentKey", slice: "read-key")
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomEnvironmentKey", slice: "set-key")
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol EnvironmentKey<Value> {

    /// The type of value stored under this key.
    associatedtype Value: Sendable

    /// The value returned when no ancestor has set one.
    static var defaultValue: Value { get }

}
