// Calligraphy
// Joined.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Join the upstreams together using a separator
    /// - Parameter separator: The separator used to join the components
    /// - Returns: The joined string components
    public func joined(
        separator: some StringProtocol
    ) -> some StringComponent {
        Joined(
            separator: separator
        ) {
            self
        }
    }

    /// Join the upstreams together using a declarative separator
    /// - Parameter components: The separator used to join the components
    /// - Returns: The joined string components
    public func joined(
        @StringBuilder by components: () -> some StringComponent
    ) -> some StringComponent {
        Joined(
            content: { self },
            separator: components
        )
    }

}

/// A joined string component
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Joined<T, Separator>: StringComponent where T: StringComponent, Separator: StringComponent {

    // MARK: - Initializers

    /// Create a joined string component
    /// - Parameters:
    ///   - content: The string components to join
    ///   - separator: The separator used to join the components
    public init(
        @StringBuilder content: () -> T,
        @StringBuilder separator: () -> Separator
    ) {
        components = content()
        self.separator = separator()
    }

    /// Create a joined string component
    /// - Parameters:
    ///   - separator: The separator used to join the components
    ///   - content: The string components to join
    public init(
        separator: some StringProtocol,
        @StringBuilder content: () -> T
    ) where Separator == RawStringComponent {
        self.init(content: content) { separator }
    }

    // MARK: - StringComponent

    public var _content: String? {
        StringEnvironment.$activeSeparator.withValue(String(separator)) {
            components._content
        }
    }

    public var body: Never {
        fatalErrorImperativeStringComponent()
    }

    // MARK: - Private

    private let components: T
    private let separator: Separator

}
