// Calligraphy
// ModifiedDirectoryContentTests.swift
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

import Calligraphy
import Foundation
import Testing

extension EnvironmentValues {

    @Entry
    var modifiedDirectoryTestName: String = "default.txt"

}

@Suite("ModifiedDirectoryContent Tests", .tags(.directoryComposition))
struct ModifiedDirectoryContentTests {

    private static func text(_ name: String, _ text: String) -> SerializedDirectoryContent {
        .text(name, permissions: .defaultFile, text: text, encoding: .utf8)
    }

    @Test("Modifier body composes around the content")
    func composes() {
        let content = File("a.txt", text: "a")
            .modifier(Licensed())

        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("LICENSE", "MIT")
        ])
    }

    @Test("Initializer matches the modifier method")
    func initializer() {
        let content = File("a.txt", text: "a")
        let modified = ModifiedDirectoryContent(
            content: content,
            modifier: Licensed()
        )

        #expect(modified._serialize() == content.modifier(Licensed())._serialize())
    }

    @Test("Modifiers chain innermost first")
    func chaining() {
        let content = File("a.txt", text: "a")
            .modifier(Wrapped(name: "inner"))
            .modifier(Wrapped(name: "outer"))

        #expect(content._serialize() == [
            .directory("outer", permissions: .defaultDirectory, content: [
                .directory("inner", permissions: .defaultDirectory, content: [
                    Self.text("a.txt", "a")
                ])
            ])
        ])
    }

    @Test("Modifiers read the surrounding environment")
    func readsEnvironment() {
        let content = File("a.txt", text: "a")
            .modifier(NamedSibling())
            .environment(\.modifiedDirectoryTestName, "b.txt")

        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("b.txt", "sibling")
        ])
    }

    @Test("Environment set in the modifier body reaches the content")
    func environmentFlowsToContent() {
        let content = File("a.txt") {
            Lines {
                "a"
                "b"
            }
        }
        .modifier(DoubleSpaced())

        #expect(content._serialize() == [
            Self.text("a.txt", "a\n\nb")
        ])
    }

    @Test("Modifier body can skip the content")
    func skipsContent() {
        let content = Files {
            File("a.txt", text: "a")
            File("b.txt", text: "b")
                .modifier(Hidden())
            File("c.txt", text: "c")
        }

        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("c.txt", "c")
        ])
    }

    @Test("Primitive modifier serializes directly")
    func primitive() {
        let content = Files {
            File("a.txt", text: "a")
            File("b.txt", text: "b")
        }
        .modifier(Reversed())

        #expect(content._serialize() == [
            Self.text("b.txt", "b"),
            Self.text("a.txt", "a")
        ])
    }

    @Test("Primitive modifier reads the surrounding environment")
    func primitiveReadsEnvironment() {
        let content = File("a.txt", text: "a")
            .modifier(NamedSuffix())
            .environment(\.modifiedDirectoryTestName, "z.txt")

        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("z.txt", "suffix")
        ])
    }

    @Test("Convenience extension returning an opaque type")
    func convenience() {
        let content = File("a.txt", text: "a")
            .licensed()

        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("LICENSE", "MIT")
        ])
    }

    @Test("Modified content writes to disk")
    func writes() async throws {
        let root = FileManager.default.temporaryDirectory
            .appending(path: "calligraphy-modified-\(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        let content = File("a.txt", text: "a")
            .modifier(Wrapped(name: "wrapped"))
            .licensed()
        try await content.write(to: root)
        let a = try String(contentsOf: root.appending(path: "wrapped/a.txt", directoryHint: .notDirectory), encoding: .utf8)
        let license = try String(contentsOf: root.appending(path: "LICENSE", directoryHint: .notDirectory), encoding: .utf8)
        #expect(a == "a")
        #expect(license == "MIT")
    }

}

private struct Licensed: DirectoryContentModifier {

    func body(content: Content) -> some DirectoryContent {
        content
        File("LICENSE", text: "MIT")
    }

}

private struct Wrapped: DirectoryContentModifier {

    let name: String

    func body(content: Content) -> some DirectoryContent {
        Folder(name) {
            content
        }
    }

}

private struct NamedSibling: DirectoryContentModifier {

    @Environment(\.modifiedDirectoryTestName)
    private var name

    func body(content: Content) -> some DirectoryContent {
        content
        File(name, text: "sibling")
    }

}

private struct DoubleSpaced: DirectoryContentModifier {

    func body(content: Content) -> some DirectoryContent {
        content
            .lineSpacing(2)
    }

}

private struct Hidden: DirectoryContentModifier {

    func body(content: Content) -> some DirectoryContent {
        if false {
            content
        }
    }

}

private struct Reversed: DirectoryContentModifier {

    func body(content: Content) -> Never {
        fatalError()
    }

    func serialize(content: Content, in environment: EnvironmentValues) -> [SerializedDirectoryContent] {
        content._serialize(in: environment).reversed()
    }

}

private struct NamedSuffix: DirectoryContentModifier {

    @Environment(\.modifiedDirectoryTestName)
    private var name

    func body(content: Content) -> Never {
        fatalError()
    }

    func serialize(content: Content, in environment: EnvironmentValues) -> [SerializedDirectoryContent] {
        content._serialize(in: environment) + [
            .text(name, permissions: .defaultFile, text: "suffix", encoding: .utf8)
        ]
    }

}

extension DirectoryContent {

    fileprivate func licensed() -> some DirectoryContent {
        modifier(Licensed())
    }

}
