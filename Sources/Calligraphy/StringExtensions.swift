// Calligraphy
// StringExtensions.swift
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

/// ## Discussion
///
/// Calligraphy adds convenience initializers to allow you to easily create Swift strings from string components.
///
/// You can pass in a component directly using ``Swift/String/init(_:)``:
///
/// ```swift
/// let component = MyStringComponent()
/// let string = String(component)
/// ```
///
/// You can also pass in multiple combined components using ``Swift/String/build(_:)``:
///
/// ```swift
/// let string = String(components: { @StringBuilder () -> some StringComponent {
///     "Hello, World!"
///     "This is a declarative, multi-line string"
///     "Created with Calligraphy!"
/// })
/// ```
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension String {

    // MARK: - Initializers

    /// Create a string from a string component
    /// - Parameter component: The string component
    public init(
        _ component: some StringComponent
    ) {
        self = component._content ?? ""
    }

    /// Build a string with a `@StringBuilder`
    /// - Parameter components: The components to assemble into a string
    /// - Returns: The string
    public static func build(
        @StringBuilder _ components: () -> some StringComponent
    ) -> String {
        .init(components())
    }

}
