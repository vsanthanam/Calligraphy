// Calligraphy
// TabDefinition.swift
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

/// A representation of how a single ``Tab`` should be rendered.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum TabDefinition: Sendable {

    /// Render a literal tab character (`\t`).
    case tab

    /// Render the given number of spaces.
    case spaces(Int)

    /// The default tab definition (two spaces).
    public static let `default`: TabDefinition = .spaces(2)

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Apply a ``TabDefinition`` to this component.
    ///
    /// The supplied tab definition becomes the ``EnvironmentValues/tabDefinition`` for this component and its descendants. ``Tab`` and modifiers built on top of it (such as ``StringComponent/tabbed(_:)``) read this value when rendering.
    ///
    /// - Parameter tabDefinition: The tab definition to use.
    /// - Returns: A component whose descendants render tabs using the supplied definition.
    public func tabDefinition(
        _ tabDefinition: TabDefinition
    ) -> some StringComponent {
        modifier(
            TabDefinitionModifier(
                tabDefinition: tabDefinition
            )
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension EnvironmentValues {

    /// The current tab definition.
    ///
    /// Defaults to ``TabDefinition/default`` (two spaces). ``Tab`` and modifiers built on top of it (such as ``StringComponent/tabbed(_:)``) read this value when rendering. Set it on an ancestor component using ``StringComponent/tabDefinition(_:)``.
    @Entry
    public internal(set) var tabDefinition: TabDefinition = .default

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct TabDefinitionModifier: StringModifier {

    let tabDefinition: TabDefinition

    func body(content: Content) -> some StringComponent {
        content
            .environment(
                \.tabDefinition,
                tabDefinition
            )
    }

}
