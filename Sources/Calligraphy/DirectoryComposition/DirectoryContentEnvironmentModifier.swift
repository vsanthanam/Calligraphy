// Calligraphy
// DirectoryContentEnvironmentModifier.swift
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
extension DirectoryContent {

    /// Set an environment value identified by an ``EnvironmentKey``.
    ///
    /// The new value is visible to this content, every file and directory inside it, and every ``StringComponent`` or ``DataComponent`` rendered inside those files. Ancestors are unaffected.
    ///
    /// - Parameters:
    ///   - key: The environment key to set.
    ///   - value: The new value for the key.
    /// - Returns: Directory content that injects the new value into the environment of its descendants.
    public func environment<Key>(
        _ key: Key.Type,
        _ value: Key.Value
    ) -> some DirectoryContent where Key: EnvironmentKey {
        transformEnvironment { environment in
            environment[key] = copy value
        }
    }

    /// Set an environment value identified by a key path on ``EnvironmentValues``.
    ///
    /// The new value is visible to this content, every file and directory inside it, and every ``StringComponent`` or ``DataComponent`` rendered inside those files. Ancestors are unaffected.
    ///
    /// - Parameters:
    ///   - keyPath: The key path identifying the value to write.
    ///   - value: The new value to write.
    /// - Returns: Directory content that injects the new value into the environment of its descendants.
    public func environment<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        _ value: Value
    ) -> some DirectoryContent {
        transformEnvironment { environment in
            environment[keyPath: keyPath] = copy value
        }
    }

    /// Apply an arbitrary transformation to the environment.
    ///
    /// Use this modifier when you need to set multiple values at once, or when the new value depends on the current value.
    ///
    /// - Parameter transform: A closure that mutates the environment in place.
    /// - Returns: Directory content whose descendants are serialized with the transformed environment.
    public func transformEnvironment(
        _ transform: @escaping (inout EnvironmentValues) -> Void
    ) -> some DirectoryContent {
        modifier(
            DirectoryEnvironmentModifier(
                transform: transform
            )
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct DirectoryEnvironmentModifier: DirectoryContentModifier {

    let transform: (inout EnvironmentValues) -> Void

    func body(
        content: Content
    ) -> Never {
        fatalErrorImperativeDirectoryContentModifier()
    }

    func serialize(
        content: Content,
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        var copy = copy environment
        transform(&copy)
        return content._serialize(in: copy)
    }

}
