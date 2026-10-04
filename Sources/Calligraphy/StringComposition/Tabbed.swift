// Calligraphy
// Tabbed.swift
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

    /// Indent every line of this component with one or more tabs.
    ///
    /// - Parameters:
    ///   - count: The number of tabs to insert at the start of each line. Defaults to `1`.
    ///   - definition: An optional ``TabDefinition`` override. When `nil`, the tab definition provided by the surrounding environment is used.
    /// - Returns: A component whose lines are each indented.
    @available(*, deprecated, message: "Use tabbed(_:) and tabDefinition(_:) modifiers instead")
    @StringBuilder
    public func tabbed(
        _ count: Int = 1,
        _ definition: TabDefinition?
    ) -> some StringComponent {
        if let definition {
            tabbed(count)
                .tabDefinition(definition)
        } else {
            tabbed(count)
        }
    }

    /// Indent every line of this component with one or more tabs.
    ///
    /// Each tab is rendered according to the surrounding ``EnvironmentValues/tabDefinition`` environment value.
    /// By default, this means two spaces per tab. Use the ``StringComponent/tabDefinition(_:)`` modifier to change it. Blank lines are left empty rather than indented.
    ///
    /// - Parameter count: The number of tabs to insert at the start of each line. Defaults to `1`.
    /// - Returns: A component whose lines are each indented.
    @StringBuilder
    public func tabbed(
        _ count: Int = 1,
    ) -> some StringComponent {
        modifier(
            TabbedModifier(
                count
            )
        )
    }

}

/// A string component that indents every line of its content with one or more tabs.
///
/// Each tab is rendered according to the surrounding ``TabDefinition`` environment value. By default, this means two spaces per tab.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, message: "Use the tabbed(_:) modifier instead")
public struct Tabbed<Content>: StringComponent where Content: StringComponent {

    // MARK: - Initializers

    /// Create an indented component.
    /// - Parameters:
    ///   - count: The number of tabs to insert at the start of each line. Defaults to `1`.
    ///   - content: The content to indent.
    public init(
        _ count: Int = 1,
        @StringBuilder content: () -> Content
    ) {
        self.count = count
        self.content = content()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        content
            .tabbed(count)
    }

    // MARK: - Private

    private let count: Int
    private let content: Content

}

private struct TabbedModifier: StringModifier {

    init(
        _ count: Int = 1
    ) {
        self.count = count
    }

    func body(content: Content) -> some StringComponent {
        content
            .prefixLines { line in
                !line.isEmpty
            } with: {
                Line {
                    ForEach(0..<count) { _ in
                        Tab()
                    }
                }
            }
    }

    // MARK: - Private

    private let count: Int

}
