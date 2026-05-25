// Calligraphy
// Joined.swift
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

    /// Join the children of this component using the given separator.
    ///
    /// The supplied separator becomes the ``StringEnvironmentValues/separator`` for this component and its descendants. Components that compose their children (such as ``Lines``) read this value to decide how to combine them.
    ///
    /// - Parameter separator: The string to insert between each child.
    /// - Returns: A component that renders its children separated by `separator`.
    public func joined(
        separator: some StringProtocol
    ) -> some StringComponent {
        Joined(
            components: self,
            separator: String(
                separator
            )
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringEnvironmentValues {

    /// The separator inserted between adjacent children of a composing component.
    ///
    /// Defaults to `"\n"`. Components such as ``Lines`` read this value to decide how to join their children. Set it on an ancestor component using ``StringComponent/joined(separator:)``.
    @StringEntry
    public internal(set) var separator: String = "\n"

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct Joined<Components>: StringComponent where Components: StringComponent {

    let components: Components

    let separator: String

    var body: some StringComponent {
        components
            .environment(
                \.separator,
                separator
            )
    }

}
