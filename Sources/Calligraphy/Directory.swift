// Calligraphy
// Directory.swift
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

/// A type representing a directory
///
/// You can implement `Directory` either declaratively, by implemeting the ``body`` property, or declaratively, by implementing the ``contents`` property.
/// Do not implement both. If you do, the `content` property will be respected and the `body` property would be ignored.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol Directory: DirectoryContent {

    /// The type of the directory's contents, if implemented declaratively
    associatedtype Body: DirectoryContent = Never

    /// The name of the directory
    var name: String { get }

    /// The contents of the directory, if implemented declaratively
    @DirectoryContentBuilder
    var body: Body { get }

    /// The serialized contents of the directory
    var contents: [SerializedDirectoryContent] { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: DirectoryContent {

    public func _serialize() -> [SerializedDirectoryContent] {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Directory where Body: DirectoryContent {

    public var contents: [SerializedDirectoryContent] {
        body._serialize()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Directory where Body == Never {

    @available(*, unavailable)
    public var contents: [SerializedDirectoryContent] {
        fatalError()
    }

    public var body: Never {
        fatalError("Directory \(Self.self) does not have a body. Do not invoke this property directly.")
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Directory {

    public func _serialize() -> [SerializedDirectoryContent] {
        [.directory(name, contents: contents)]
    }

}
