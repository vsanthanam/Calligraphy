// Calligraphy
// MapLines.swift
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

import Foundation

/// Rules to use when appling a line mapping modifier
///
/// Instances of this enum are used to augment line mapping modifiers, such as ``StringComponent/mapLines(_:_:)``, ``StringComponents/prefixLines(with:_:)``, and ``StringComponents/suffixLines(with:_:)``
public enum MapLinesRule: Equatable, Sendable {

    /// Apply the mapper function to every line
    case all

    /// Apply the mapper function only to lines that are not empty
    case notEmpty

    /// Apply the mapper function only to lines that are empty
    case empty

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Map every line of the upstream using a mapper function, declaratively
    /// - Parameters:
    ///   - rule: The rule used to determine which lines should get mapped
    ///   - components: The StringBuilder used to map each applicable line
    /// - Returns: A mapped version of the upstream
    public func mapLines(
        _ rule: MapLinesRule = .all,
        with components: @Sendable @escaping (String) -> some StringComponent
    ) -> some StringComponent {
        MapLines(self, rule) { line in
            String(components(line))
        }
    }

    /// Map every line of the upstream using a mapper function
    /// - Parameters:
    ///   - rule: The rule used to determine which lines should get mapped
    ///   - fn: The function used to map each applicable line
    /// - Returns: A mapepd version of the upstream
    public func mapLines(
        _ rule: MapLinesRule = .all,
        _ fn: @Sendable @escaping (String) -> String?
    ) -> some StringComponent {
        MapLines(self, rule, fn)
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct MapLines<T>: StringComponent where T: StringComponent {

    // MARK: - Initializers

    init(
        _ lines: T,
        _ rule: MapLinesRule,
        _ fn: @Sendable @escaping (String) -> String?
    ) {
        self.lines = lines
        self.rule = rule
        self.fn = fn
    }

    // MARK: - StringComponent

    var body: some StringComponent {
        switch rule {
        case .all:
            lines
                .map { content in
                    guard let content else { return nil }
                    return content
                        .components(separatedBy: "\n")
                        .compactMap(fn)
                        .joined(separator: "\n")
                }
        case .notEmpty:
            lines
                .map { content in
                    guard let content else { return nil }
                    return content
                        .components(separatedBy: "\n")
                        .compactMap { component in
                            if component == "" {
                                component
                            } else {
                                fn(component)
                            }
                        }
                        .joined(separator: "\n")
                }
        case .empty:
            lines
                .map { content in
                    guard let content else { return nil }
                    return content
                        .components(separatedBy: "\n")
                        .compactMap { component in
                            if component == "" {
                                fn(component)
                            } else {
                                component
                            }
                        }
                        .joined(separator: "\n")
                }
        }
    }

    private let lines: T
    private let rule: MapLinesRule
    private let fn: @Sendable (String) -> String?

}
