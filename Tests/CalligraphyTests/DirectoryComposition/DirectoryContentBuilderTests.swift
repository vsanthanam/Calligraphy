// Calligraphy
// DirectoryContentBuilderTests.swift
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

@testable import Calligraphy
import Foundation
import Testing

@Suite("@DirectoryContentBuilder Tests", .tags(.directoryComposition))
struct DirectoryContentBuilderTests {

    @Test("Serialized Content (Array) Expression")
    func arrayExpression() {

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            [.text("foo", permissions: .defaultFile, text: "bar", encoding: .utf8)]
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._AlreadySerialized)
        #expect(components._serialize() == [.text("foo", permissions: .defaultFile, text: "bar", encoding: .utf8)])
    }

    @Test("Serialized Content Expression")
    func contentExpression() {

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            .text("foo", permissions: .defaultFile, text: "bar", encoding: .utf8)
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._AlreadySerialized)
        #expect(components._serialize() == [.text("foo", permissions: .defaultFile, text: "bar", encoding: .utf8)])
    }

    @Test("No Components")
    func noComponents() {

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {}

        let components = builder()
        #expect(components is EmptyDirectoryContent)
        #expect(components._serialize() == [])
    }

    @Test("One Component")
    func singleComponent() {
        struct Foo: Directory {

            let name = "Foo"

            var body: some DirectoryContent {}

        }

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            Foo()
        }

        let components = builder()
        #expect(components is Foo)
        #expect(components._serialize() == [.directory("Foo", permissions: .defaultDirectory, content: [])])
    }

    @Test("Multiple Components")
    func multipleComponents() {
        struct Foo: Directory {

            let name = "Foo"

            var body: some DirectoryContent {}

        }

        struct Bar: TextFile {

            let name: String = "Bar"

            var body: some StringComponent {
                "bar"
            }
        }

        struct Baz: DataFile {

            let name: String = "Baz"

            var body: some DataComponent {}
        }

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            Foo()
            Bar()
            Baz()
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._Block<Foo, Bar, Baz>)

        let expected = [
            SerializedDirectoryContent.directory("Foo", permissions: .defaultDirectory, content: []),
            SerializedDirectoryContent.text("Bar", permissions: .defaultFile, text: "bar", encoding: .utf8),
            SerializedDirectoryContent.data("Baz", permissions: .defaultFile, data: Data())
        ]
        #expect(components._serialize() == expected)
    }

    @Test(
        "If/Else Support",
        arguments: [
            (true, [SerializedDirectoryContent.directory("Foo", permissions: .defaultDirectory, content: [])]),
            (false, [SerializedDirectoryContent.text("Bar", permissions: .defaultFile, text: "bar", encoding: .utf8)])
        ]
    )
    func ifElse(flow: Bool, result: [SerializedDirectoryContent]) {

        struct Foo: Directory {

            let name = "Foo"

            var body: some DirectoryContent {}

        }

        struct Bar: TextFile {

            let name: String = "Bar"

            var body: some StringComponent {
                "bar"
            }
        }

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            if flow {
                Foo()
            } else {
                Bar()
            }
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._Either<Foo, Bar>)
        #expect(components._serialize() == result)
    }

    @Test(
        "Single If Support",
        arguments: [
            (true, [SerializedDirectoryContent.directory("Foo", permissions: .defaultDirectory, content: []), SerializedDirectoryContent.text("Bar", permissions: .defaultFile, text: "bar", encoding: .utf8)]),
            (false, [SerializedDirectoryContent.text("Bar", permissions: .defaultFile, text: "bar", encoding: .utf8)])
        ]
    )
    func singleIf(flow: Bool, result: [SerializedDirectoryContent]) {

        struct Foo: Directory {

            let name = "Foo"

            var body: some DirectoryContent {}

        }

        struct Bar: TextFile {

            let name: String = "Bar"

            var body: some StringComponent {
                "bar"
            }
        }

        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            if flow {
                Foo()
            }
            Bar()
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._Block<DirectoryContentBuilder._Either<Foo, EmptyDirectoryContent>, Bar>)
        #expect(components._serialize() == result)
    }

    @Test("For Loop Support")
    func forLoop() {
        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            for i in 0 ..< 8 {
                if i % 2 == 0 {
                    File("\(i+1)", fileExtension: "txt") { "\(i)-bar" }
                }
            }
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._List<DirectoryContentBuilder._Either<File, EmptyDirectoryContent>>)

        let expected = [
            SerializedDirectoryContent.text("1.txt", permissions: .defaultFile, text: "0-bar", encoding: .utf8),
            SerializedDirectoryContent.text("3.txt", permissions: .defaultFile, text: "2-bar", encoding: .utf8),
            SerializedDirectoryContent.text("5.txt", permissions: .defaultFile, text: "4-bar", encoding: .utf8),
            SerializedDirectoryContent.text("7.txt", permissions: .defaultFile, text: "6-bar", encoding: .utf8)
        ]

        #expect(components._serialize() == expected)
    }

//
    @Test("Availablility Check Support")
    func availabilityCheck() {
        @DirectoryContentBuilder
        func builder() -> some DirectoryContent {
            if #available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *) {
                Folder("Foo") {}
            }
        }

        let components = builder()
        #expect(components is DirectoryContentBuilder._Either<AnyDirectoryContent, EmptyDirectoryContent>)
        #expect(components._serialize() == [.directory("Foo", permissions: .defaultDirectory, content: [])])
    }

}
