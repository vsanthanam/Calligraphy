// Calligraphy
// PrefixLines.swift
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

import Foundation

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    /// Prepend a component to every line in this component's rendered output.
    ///
    /// The receiver is rendered first, then each newline-separated line in the result is prefixed with the value produced by `prefix`. This is the standard way to add gutters, comment markers, or indentation to a multi-line block.
    ///
    /// - Parameters:
    ///   - predicate: A closure that receives each rendered line and returns whether it should be prefixed. Lines for which it returns `false` are emitted unchanged. Defaults to prefixing every line.
    ///   - prefix: A `@StringBuilder` closure producing the component to insert at the start of each matching line.
    /// - Returns: A component whose lines are each prefixed.
    public func prefixLines(
        when predicate: @escaping (String) -> Bool = { _ in true },
        @StringBuilder with prefix: () -> some StringComponent
    ) -> some StringComponent {
        modifier(
            PrefixLinesModifier(
                prefix: prefix(),
                predicate: predicate
            )
        )
    }

    /// Prepend a string to every line in this component's rendered output.
    ///
    /// - Parameters:
    ///   - predicate: A closure that receives each rendered line and returns whether it should be prefixed. Lines for which it returns `false` are emitted unchanged. Defaults to prefixing every line.
    ///   - prefix: The string to insert at the start of each matching line.
    /// - Returns: A component whose lines are each prefixed.
    public func prefixLines(
        when predicate: @escaping (String) -> Bool = { _ in true },
        with prefix: some StringProtocol
    ) -> some StringComponent {
        prefixLines(when: predicate) {
            prefix
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct PrefixLinesModifier<Prefix>: StringModifier where Prefix: StringComponent {

    let prefix: Prefix

    let predicate: (String) -> Bool

    func body(
        content: Content
    ) -> Never {
        fatalErrorImperativeStringModifier()
    }

    func render(
        content: Content,
        in environment: EnvironmentValues
    ) -> String? {
        guard let rendered = content._render(in: environment) else {
            return nil
        }
        return rendered
            .components(separatedBy: "\n")
            .map { line in
                guard predicate(line) else {
                    return line
                }
                return (prefix + line)._render(in: environment) ?? line
            }
            .joined(separator: "\n")
    }

}
