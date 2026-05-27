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

    /// Set an environment value identified by a key path on ``StringEnvironmentValues``.
    ///
    /// The new value is visible to this component and all of its descendants. Ancestor components are unaffected.
    ///
    /// - Parameters:
    ///   - keyPath: The key path identifying the value to write.
    ///   - value: The new value to write.
    /// - Returns: A component that injects the new value into the environment of its descendants.
    public func environment<Value>(
        _ keyPath: WritableKeyPath<StringEnvironmentValues, Value>,
        _ value: Value
    ) -> some StringComponent {
        EnvironmentModifier(
            upstream: self
        ) { environment in
            environment[keyPath: keyPath] = value
        }
    }

    /// Transforms the environment value of the specified key path on ``StringEnvironmentValues`` with the given function.
    /// - Parameters:
    ///   - keyPath: The key path identifying the value to transform
    ///   - transform: The function used transform the value
    /// - Returns: A component that transforms the value before providing it to its descendants.
    public func transformEnvironment<V>(
        _ keyPath: WritableKeyPath<StringEnvironmentValues, V>,
        transform: @escaping (inout V) -> Void
    ) -> some StringComponent {
        EnvironmentModifier(upstream: self) { environment in
            var value = environment[keyPath: keyPath]
            transform(&value)
            environment[keyPath: keyPath] = value
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct EnvironmentModifier<Upstream>: StringComponent where Upstream: StringComponent {

    let upstream: Upstream

    let transform: (inout StringEnvironmentValues) -> Void

    var body: Never {
        fatalErrorImperativeStringComponent()
    }

    func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        var copy = environment
        transform(&copy)
        return upstream.render(in: copy)
    }

}
