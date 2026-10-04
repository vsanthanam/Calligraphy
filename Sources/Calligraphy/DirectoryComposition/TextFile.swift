// Calligraphy
// TextFile.swift
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

/// A file containing a `String`
///
/// A `TextFile` renders its ``body`` in the environment it was placed in, so values set on an enclosing ``Folder`` with ``DirectoryContent/environment(_:_:)-(_,Value)`` are visible to the components inside the file. Any ``Environment`` properties declared on the file itself are resolved against that same environment, the same way a SwiftUI view reads the environment set by its parent.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol TextFile: DirectoryContent {

    /// The name of the file
    var name: String { get }

    /// The permissions of the file
    var permissions: FilePermissions { get }

    /// The encoding to use when the file is written to disk.
    ///
    /// The file's encoding. Defaults to `.utf8`. Unicode encodings are supported on every platform.
    /// Legacy encodings such as `.macOSRoman` or `.shiftJIS` depend on platform support and may cause the write to fail on Linux.
    var encoding: String.Encoding { get }

    /// The type of string component representing the contents of this file.
    ///
    /// Typically, you do not need to explicitly spell out this type.
    /// Instead, implement ``body`` using an opaque type, and allow the compiler to expand the result builder and choose the correct type to satisfy the protocol.
    associatedtype Body: StringComponent

    /// The string components used to build the contents of this file.
    @StringBuilder
    var body: Body { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension TextFile {

    public var permissions: FilePermissions {
        .defaultFile
    }

    public var encoding: String.Encoding {
        .utf8
    }

    public func _serialize(
        in environment: EnvironmentValues
    ) -> [SerializedDirectoryContent] {
        environment.inject(into: self)
        return [
            .text(
                name,
                permissions: permissions,
                text: body.fileName(name).render(in: environment) ?? "",
                encoding: encoding
            )
        ]
    }

}
