// Calligraphy
// SharedEnvironmentTests.swift
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

@testable import Calligraphy
import Foundation
import Testing

private struct SharedKey: EnvironmentKey {
    static let defaultValue: String = "default"
}

extension EnvironmentValues {

    @Entry
    var sharedTestValue: String = "default"

}

@Suite("Shared Environment Tests", .tags(.environment, .directoryComposition, .dataComposition))
struct SharedEnvironmentTests {

    private struct Reader: StringComponent {

        @Environment(\.sharedTestValue)
        var value: String

        var body: some StringComponent {
            value
        }

    }

    private struct ByteReader: DataComponent {

        @Environment(\.sharedTestValue)
        var value: String

        var body: some DataComponent {
            Data(value.utf8)
        }

    }

    private struct ReaderTextFile: TextFile {

        let name = "reader.txt"

        @Environment(\.sharedTestValue)
        var value: String

        var body: some StringComponent {
            "file:" + value
        }

    }

    private struct ReaderDataFile: DataFile {

        let name = "reader.bin"

        @Environment(\.sharedTestValue)
        var value: String

        var body: some DataComponent {
            Data(value.utf8)
        }

    }

    private struct ReaderDirectory: Directory {

        let name = "reader"

        @Environment(\.sharedTestValue)
        var value: String

        var body: some DirectoryContent {
            File("value.txt", text: value)
        }

    }

    private final class Counter {
        var count = 0
    }

    private struct Counting: StringComponent {

        let counter: Counter

        var body: Never {
            fatalError()
        }

        func _render(in environment: borrowing EnvironmentValues) -> String? {
            counter.count += 1
            return "rendered"
        }

    }

    private func text(of content: [SerializedDirectoryContent], at path: [String]) -> String? {
        var current = content
        for (index, component) in path.enumerated() {
            guard let match = current.first(where: { $0.name == component }) else {
                return nil
            }
            switch match.content {
            case let .directory(children):
                current = children
            case let .file(.text(text, _)):
                return index == path.count - 1 ? text : nil
            case let .file(.data(data)):
                return index == path.count - 1 ? String(decoding: data, as: UTF8.self) : nil
            }
        }
        return nil
    }

    @Test("Value set on a folder reaches string components in nested files")
    func folderToString() {
        let content = Folder("A") {
            Folder("B") {
                File("c.txt") {
                    Reader()
                }
            }
        }
        .environment(\.sharedTestValue, "from-folder")
        #expect(text(of: content._serialize(), at: ["A", "B", "c.txt"]) == "from-folder")
    }

    @Test("Value set on a folder reaches data components in nested files")
    func folderToData() {
        let content = Folder("A") {
            File("c.bin") {
                ByteReader()
            }
        }
        .environment(\.sharedTestValue, "bytes")
        #expect(text(of: content._serialize(), at: ["A", "c.bin"]) == "bytes")
    }

    @Test("Built-in string values set on a folder change rendering")
    func builtInValue() {
        let content = Folder("A") {
            File("c.txt") {
                Lines {
                    "one"
                    "two"
                }
            }
        }
        .lineSpacing(2)
        #expect(text(of: content._serialize(), at: ["A", "c.txt"]) == "one\n\ntwo")
    }

    @Test("Tab definition and quotation mark style set on a folder change rendering")
    func builtInFormattingValues() {
        let content = Folder("A") {
            File("t.txt") {
                Tab()
                "x"
            }
            File("q.txt") {
                Quote {
                    "x"
                }
            }
        }
        .tabDefinition(.spaces(4))
        .quotationMarkStyle(.single)
        let serialized = content._serialize()
        #expect(text(of: serialized, at: ["A", "t.txt"]) == "    \nx")
        #expect(text(of: serialized, at: ["A", "q.txt"]) == "'x'")
    }

    @Test("Key-based and transform modifiers on directory content")
    func directoryKeyAndTransform() {
        struct KeyReader: StringComponent {
            @Environment(SharedKey.self)
            var value: String
            var body: some StringComponent {
                value
            }
        }
        let byKey = File("k.txt") {
            KeyReader()
        }
        .environment(SharedKey.self, "keyed")
        #expect(text(of: byKey._serialize(), at: ["k.txt"]) == "keyed")

        let transformed = File("t.txt") {
            Reader()
        }
        .transformEnvironment { environment in
            environment.sharedTestValue += "b"
        }
        .environment(\.sharedTestValue, "a")
        #expect(text(of: transformed._serialize(), at: ["t.txt"]) == "ab")
    }

    @Test("Key-based and transform modifiers on data components")
    func dataKeyAndTransform() {
        struct KeyReader: DataComponent {
            @Environment(SharedKey.self)
            var value: String
            var body: some DataComponent {
                Data(value.utf8)
            }
        }
        let byKey = KeyReader().environment(SharedKey.self, "keyed")
        #expect(Data(byKey) == Data("keyed".utf8))

        let transformed = ByteReader()
            .transformEnvironment { environment in
                environment.sharedTestValue += "b"
            }
            .environment(\.sharedTestValue, "a")
        #expect(Data(transformed) == Data("ab".utf8))
    }

    @Test("TextFile, DataFile, and Directory conformers receive injected values")
    func conformerInjection() {
        let content = Folder("root") {
            ReaderTextFile()
            ReaderDataFile()
            ReaderDirectory()
        }
        .environment(\.sharedTestValue, "injected")
        let serialized = content._serialize()
        #expect(text(of: serialized, at: ["root", "reader.txt"]) == "file:injected")
        #expect(text(of: serialized, at: ["root", "reader.bin"]) == "injected")
        #expect(text(of: serialized, at: ["root", "reader", "value.txt"]) == "injected")
    }

    @Test("File renders lazily at serialization time")
    func lazyRendering() {
        let counter = Counter()
        let file = File("lazy.txt") {
            Counting(counter: counter)
        }
        #expect(counter.count == 0)
        _ = file._serialize()
        #expect(counter.count == 1)
        _ = file._serialize()
        #expect(counter.count == 2)
    }

}
