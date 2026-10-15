// Calligraphy
// FileLocationEnvironment.swift
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

/// Shared path arithmetic for the location property wrappers.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper
struct FileLocationEnvironment: DynamicProperty {

    // MARK: - Property Wrapper

    var wrappedValue: Self {
        self
    }

    // MARK: - API

    func path(
        to components: [String],
        resolution: PathResolution
    ) -> String? {
        switch resolution {
        case .relative:
            components.joined(separator: "/")
        case .absolute:
            url(to: components, isDirectory: true).map { url in
                let path = url.path(percentEncoded: false)
                guard path.count > 1, path.hasSuffix("/") else {
                    return path
                }
                return String(path.dropLast())
            }
        }
    }

    func url(
        to components: [String],
        isDirectory: Bool
    ) -> URL? {
        guard let destination else {
            return nil
        }
        guard !components.isEmpty else {
            return destination
        }
        return destination.appending(
            path: components.joined(separator: "/"),
            directoryHint: isDirectory ? .isDirectory : .notDirectory
        )
    }

    // MARK: - Private

    @Environment(\.destinationDirectoryURL)
    private var destination

}
