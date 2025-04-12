// Calligraphy
// Delimited.swift
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

    public func delimited(
        by delimiter: String
    ) -> some StringComponent {
        Delimited(
            by: delimiter
        ) {
            self
        }
    }

    public func delimited(
        @StringBuilder with components: () -> some StringComponent
    ) -> some StringComponent {
        Delimited(
            components: { self },
            delimiter: components
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Delimited<T, Delimiter>: StringComponent where T: StringComponent, Delimiter: StringComponent {

    // MARK: - Initializers

    public init(
        by delimiter: String,
        @StringBuilder components: () -> T
    ) where Delimiter == RawStringComponent {
        self.init(components: components) { delimiter }
    }

    public init(
        @StringBuilder components: () -> T,
        @StringBuilder delimiter: () -> Delimiter
    ) {
        self.components = components()
        self.delimiter = delimiter()
    }

    // MARK: - StringComponent

    public var body: some StringComponent {
        delimiter + components + delimiter
    }

    // MARK: - Private

    private let components: T
    private let delimiter: Delimiter

}
