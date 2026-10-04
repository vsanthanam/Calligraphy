// Calligraphy
// EnvironmentModifier.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Set an environment value identified by a ``EnvironmentKey``.
    ///
    /// The new value is visible to this component and all of its descendants. Ancestor components are unaffected.
    ///
    /// - Parameters:
    ///   - key: The environment key to set.
    ///   - value: The new value for the key.
    /// - Returns: A component that injects the new value into the environment of its descendants.
    public func environment<Key>(
        _ key: Key.Type,
        _ value: consuming Key.Value
    ) -> some StringComponent where Key: EnvironmentKey {
        transformEnvironment { environment in
            environment[key] = copy value
        }
    }

    /// Set an environment value identified by a key path on ``EnvironmentValues``.
    ///
    /// The new value is visible to this component and all of its descendants. Ancestor components are unaffected.
    ///
    /// - Parameters:
    ///   - keyPath: The key path identifying the value to write.
    ///   - value: The new value to write.
    /// - Returns: A component that injects the new value into the environment of its descendants.
    public func environment<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        _ value: consuming Value
    ) -> some StringComponent {
        transformEnvironment { environment in
            environment[keyPath: keyPath] = copy value
        }
    }

    /// Apply an arbitrary transformation to the environment.
    ///
    /// Use this modifier when you need to set multiple values at once, or when the new value depends on the current value.
    ///
    /// - Parameter transform: A closure that mutates the environment in place.
    /// - Returns: A component whose descendants render with the transformed environment.
    public func transformEnvironment(
        _ transform: consuming @escaping (inout EnvironmentValues) -> Void
    ) -> some StringComponent {
        modifier(
            EnvironmentModifier(
                transform: transform
            )
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct EnvironmentModifier: StringModifier {

    let transform: (inout EnvironmentValues) -> Void

    func body(
        content: Content
    ) -> Never {
        fatalErrorImperativeStringModifier()
    }

    func render(
        content: Content,
        in environment: borrowing EnvironmentValues
    ) -> String? {
        var copy = copy environment
        transform(&copy)
        return content._render(in: copy)
    }

}
