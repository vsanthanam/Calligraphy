// Calligraphy
// Map.swift
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

    func map(
        _ fn: @Sendable @escaping (String?) -> String?
    ) -> some StringComponent {
        Map(self, fn)
    }

    func map(
        @StringBuilder with components: @Sendable @escaping (String?) -> some StringComponent
    ) -> some StringComponent {
        Map(self) { content in
            String(components(content))
        }
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
private struct Map<T>: StringComponent where T: StringComponent {

    // MARK: - Initializers

    init(
        _ upstream: T,
        _ fn: @Sendable @escaping (String?) -> String?
    ) {
        self.upstream = upstream
        self.fn = fn
    }

    // MARK: - StringComponent

    var content: String? {
        fn(upstream.content)
    }

    // MARK: - Private

    private let upstream: T
    private let fn: @Sendable (String?) -> String?
}
