// Calligraphy
// SuffixLines.swift
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

    /// Suffix every line of the upstream
    /// - Parameters:
    ///   - suffix: The suffix to apply to every applicable line
    ///   - rule: The rule used to determine which lines should get suffixed
    /// - Returns: A suffixed version of the upstream
    public func suffixLines(
        with suffix: some StringProtocol,
        _ rule: MapLinesRule = .all
    ) -> some StringComponent {
        suffixLines(rule) { suffix }
    }

    /// Suffix every line of the upstream, declaratively
    /// - Parameters:
    ///   - rule: The suffix to apply to every applicable line
    ///   - components: The `@StringBuilder` suffix to apply to every applicable line
    /// - Returns: A suffixed version of the upstream
    public func suffixLines(
        _ rule: MapLinesRule = .all,
        @StringBuilder components: () -> some StringComponent
    ) -> some StringComponent {
        SuffixLines(
            self,
            rule,
            components()
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct SuffixLines<Lines, Suffix>: StringComponent where Lines: StringComponent, Suffix: StringComponent {

    // MARK: - Initializers

    init(
        _ lines: Lines,
        _ rule: MapLinesRule,
        _ suffix: Suffix
    ) {
        self.lines = lines
        self.rule = rule
        self.suffix = suffix
    }

    // MARK: - StringComponent

    var body: some StringComponent {
        lines
            .mapLines(rule) { line in
                line + suffix
            }
    }

    // MARK: - Private

    private let lines: Lines
    private let rule: MapLinesRule
    private let suffix: Suffix

}
