// Calligraphy
// StringDynamicProperty.swift
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

/// A property wrapper that participates in the ``StringComponent`` render lifecycle.
///
/// Conform a property wrapper to `StringDynamicProperty` to give it a chance to update its internal state from the surrounding ``StringEnvironmentValues`` before the enclosing component's ``StringComponent/body`` is evaluated. The built-in ``StringEnvironment`` wrapper conforms to this protocol, and you can use the same mechanism to write your own wrappers — for example, a wrapper that derives a cached value from one or more environment values, or one that exposes a deterministic seed for content generation.
///
/// ```swift
/// @propertyWrapper
/// struct Indented: StringDynamicProperty {
///
///     @StringEnvironment(\.tabDefinition)
///     private var tab: TabDefinition
///
///     private let box = Box()
///
///     var wrappedValue: String {
///         box.value
///     }
///
///     func update(in environment: StringEnvironmentValues) {
///         box.value = tab.value
///     }
///
///     private final class Box {
///         var value: String = ""
///     }
///
/// }
/// ```
///
/// Dynamic properties are updated recursively: if a `StringDynamicProperty` has its own stored `StringDynamicProperty` fields (such as the nested ``StringEnvironment`` above), those are updated before the enclosing wrapper's `update(in:)` reads them. Wrappers are expected to be value types — reference cycles via class-backed storage are the caller's responsibility.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol StringDynamicProperty {

    /// Update this property's state from the surrounding environment.
    ///
    /// Called once per render of the enclosing ``StringComponent``, immediately before its ``StringComponent/body`` is evaluated.
    ///
    /// - Parameter environment: The environment values flowing into the enclosing component.
    func update(in environment: StringEnvironmentValues)

}

extension StringDynamicProperty {

    public func update(
        in environment: StringEnvironmentValues
    ) {}

}
