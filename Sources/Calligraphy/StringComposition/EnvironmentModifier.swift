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

    public func environment<Key>(
        _ key: Key.Type,
        _ value: Key.Value
    ) -> some StringComponent where Key: StringEnvironmentKey {
        EnvironmentModifier(
            upstream: self
        ) { environment in
            environment[key] = value
        }
    }

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

    public func transformEnvironment(
        _ transform: @escaping (inout StringEnvironmentValues) -> Void
    ) -> some StringComponent {
        EnvironmentModifier(
            upstream: self,
            transform: transform
        )
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
