// Calligraphy
// DirectoryContentFormattingModifiers.swift
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
extension DirectoryContent {

    /// Set the number of newlines that ``Lines`` uses to separate adjacent children, for every file inside this content.
    ///
    /// This is the directory counterpart of ``StringComponent/lineSpacing(_:)``.
    /// The value flows through the environment into every text file beneath this content, however deeply nested. Apply the modifier again to a nested component to give it a different spacing.
    ///
    /// - Parameter count: The number of newlines used to separate lines. Use `1` for normal single-spacing, `2` for one blank line between each pair of lines, and so on.
    /// - Returns: Directory content whose files render with the supplied line spacing.
    public func lineSpacing(
        _ count: Int
    ) -> some DirectoryContent {
        environment(
            \.lineSpacing,
            count
        )
    }

    /// Apply a ``TabDefinition`` to every file inside this content.
    ///
    /// This is the directory counterpart of ``StringComponent/tabDefinition(_:)``.
    /// The supplied tab definition becomes the ``EnvironmentValues/tabDefinition`` for every component rendered inside this content.
    ///
    /// - Parameter tabDefinition: The tab definition to use.
    /// - Returns: Directory content whose files render tabs using the supplied definition.
    public func tabDefinition(
        _ tabDefinition: TabDefinition
    ) -> some DirectoryContent {
        environment(
            \.tabDefinition,
            tabDefinition
        )
    }

    /// Apply a ``QuotationMarkStyle`` to every file inside this content.
    ///
    /// This is the directory counterpart of ``StringComponent/quotationMarkStyle(_:)``.
    /// The supplied style becomes the ``EnvironmentValues/quotationMarkStyle`` for every component rendered inside this content.
    ///
    /// - Parameter style: The style of quotation mark to use.
    /// - Returns: Directory content whose files render quotation marks with the supplied style.
    public func quotationMarkStyle(
        _ style: QuotationMarkStyle
    ) -> some DirectoryContent {
        environment(
            \.quotationMarkStyle,
            style
        )
    }

}
