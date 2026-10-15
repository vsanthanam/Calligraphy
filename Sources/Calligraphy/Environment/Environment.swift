// Calligraphy
// Environment.swift
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

/// A property wrapper that reads a value from the surrounding ``EnvironmentValues``.
///
/// Use `Environment` inside a ``StringComponent``, ``DataComponent``, ``TextFile``, ``DataFile``, or ``Directory`` to read values that have been injected by ancestor components. The wrapper resolves its value lazily, at the moment the component is rendered.
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/ReadingEnvironmentValues", slice: "property-wrapper")
///
/// - Note: SwiftUI declares a property wrapper with the same name. In a file that imports both modules, write `@Calligraphy.Environment` to disambiguate.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper
public struct Environment<Value>: DynamicProperty {

    // MARK: - Initializers

    /// Read a value from ``EnvironmentValues`` by key path.
    /// - Parameter keyPath: The key path identifying the value to read.
    public init(
        _ keyPath: KeyPath<EnvironmentValues, Value>
    ) {
        self.read = { $0[keyPath: keyPath] }
    }

    /// Read a value from ``EnvironmentValues`` by ``EnvironmentKey``.
    /// - Parameter key: The key type identifying the value to read.
    public init<Key>(
        _ key: Key.Type
    ) where Key: EnvironmentKey, Value == Key.Value {
        self.read = { $0[key] }
    }

    // MARK: - Property Wrapper

    /// The current value read from the surrounding environment.
    public var wrappedValue: Value {
        read(box.values)
    }

    // MARK: - DynamicProperty

    public func _inject(
        _ values: EnvironmentValues
    ) {
        box.values = values
    }

    // MARK: - Private

    private let read: (EnvironmentValues) -> Value
    private let box = Box()

    private final class Box {
        var values = EnvironmentValues()
    }

}

/// A property wrapper that derives its value from the surrounding ``EnvironmentValues``.
///
/// ``Environment`` and ``FileName`` are dynamic properties. Conform your own property wrappers to `DynamicProperty` to have Calligraphy resolve them against the environment whenever the component, modifier, file, or directory that declares them is rendered.
///
/// A dynamic property reads the environment through other dynamic properties stored inside it, typically ``Environment``, and computes its `wrappedValue` from them. Because the environment is injected after the enclosing component is initialized, `wrappedValue` must be a computed property:
///
/// @Snippet(path: "Calligraphy/Snippets/EnvironmentValues/CustomDynamicProperty", slice: "wrapper")
///
/// The default implementation of `_inject(_:)` finds every dynamic property stored in the conforming type and injects it, so a conforming type rarely needs to do anything beyond declaring the conformance.
///
/// - Note: SwiftUI declares a protocol with the same name. In a file that imports both modules, write `Calligraphy.DynamicProperty` to disambiguate.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol DynamicProperty {

    /// Resolve this property against the environment it is being rendered in.
    ///
    /// You rarely need to implement this method. The default implementation injects every dynamic property stored in `self`. Implement it only when your property reads the environment some other way.
    ///
    /// - Parameter values: The environment values to read during rendering.
    func _inject(
        _ values: EnvironmentValues
    )

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DynamicProperty {

    public func _inject(
        _ values: EnvironmentValues
    ) {
        values.inject(into: self)
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension EnvironmentValues {

    /// Resolve every ``DynamicProperty`` declared by `subject` against this environment.
    /// - Parameter subject: The component, modifier, file, directory, or dynamic property whose stored dynamic properties should be injected.
    func inject(into subject: Any) {
        for child in Mirror(reflecting: subject).children {
            (child.value as? (any DynamicProperty))?._inject(self)
        }
    }

}
