// Calligraphy
// LineSpacing.swift
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

    /// Set the spacing between lines
    /// - Parameter spacing: The line spacing. Must be greater than or equal to 1.
    /// - Returns: The upstream, with the applied line spacing
    public func lineSpacing(
        _ spacing: Int
    ) -> some StringComponent {
        LineSpacing(
            self,
            spacing
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct LineSpacing<T>: StringComponent where T: StringComponent {

    init(
        _ wrapped: T,
        _ spacing: Int
    ) {
        precondition(spacing > 0, "Line spacing must be greater than or equal to one")
        self.wrapped = wrapped
        self.spacing = spacing
    }

    var _content: String? {
        StringEnvironment.$activeLineSpacing.withValue(spacing) {
            wrapped._content
        }
    }

    var body: Never {
        fatalErrorImperativeStringComponent()
    }

    private let wrapped: T
    private let spacing: Int

}
