// Calligraphy
// Directory.swift
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

/// A directory
///
/// A `Directory` passes its environment down to its ``body``, so values set on the directory or any ancestor with ``DirectoryContent/environment(_:_:)-(_,Value)`` are visible to every file inside it. Any ``Environment`` properties declared on the directory itself are resolved against the environment the directory was placed in, the same way a SwiftUI view reads the environment set by its parent.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol Directory: DirectoryContent {

    /// The name of the directory
    var name: String { get }

    /// The permissions of the directory
    var permissions: FilePermissions { get }

    associatedtype Body: DirectoryContent

    @DirectoryContentBuilder
    var body: Body { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: DirectoryContent {

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Directory {

    public var permissions: FilePermissions {
        .defaultDirectory
    }

    /// The serialized contents of the directory, rendered in a fresh environment.
    @available(*, deprecated, message: "Use _serialize(in:) instead")
    public var _contents: [SerializedDirectoryContent] {
        body._serialize(in: EnvironmentValues())
    }

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        environment.inject(into: self)
        return [
            .directory(
                name,
                permissions: permissions,
                content: body._serialize(in: environment)
            )
        ]
    }

}
