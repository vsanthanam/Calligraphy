// Calligraphy
// ReadEnvironment.swift
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

/// A string component that reads the surrounding ``StringEnvironmentValues`` and builds its body from them.
///
/// Use `ReadEnvironment` when the structure of your component depends on the current environment, not just on a single value. For reading a single value, prefer the ``StringEnvironment`` property wrapper.
///
/// ```swift
/// ReadEnvironment { environment in
///     if environment.separator == "\n" {
///         "Multiline"
///     } else {
///         "Inline"
///     }
/// }
/// ```
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct ReadEnvironment<Content>: StringComponent where Content: StringComponent {

    // MARK: - Initializers

    /// Create a string component that reads from the environment
    /// - Parameter build: A closure that receives the current environment and returns a component to render in its place.
    public init(
        @StringBuilder _ build: @escaping (StringEnvironmentValues) -> Content
    ) {
        self.build = build
    }

    // MARK: - StringComponent

    public var body: Never {
        fatalError()
    }

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        build(environment).render(in: environment)
    }

    // MARK: - Private

    private let build: (StringEnvironmentValues) -> Content

}
