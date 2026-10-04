// Calligraphy
// DirectoryForEachTests.swift
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

@Suite("ForEach Directory Tests", .tags(.directoryComposition))
struct DirectoryForEachTests {

    private static func text(_ name: String, _ text: String) -> SerializedDirectoryContent {
        .text(name, permissions: .defaultFile, text: text, encoding: .utf8)
    }

    @Test("Files are listed in order")
    func files() {
        let content = ForEach(["a", "b", "c"]) { name in
            File(name, fileExtension: "txt", text: name)
        }
        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            Self.text("b.txt", "b"),
            Self.text("c.txt", "c")
        ])
    }

    @Test("Each element can produce multiple entries")
    func multipleEntries() {
        let content = ForEach(["a", "b"]) { name in
            File(name, fileExtension: "txt", text: name)
            Folder(name) {}
        }
        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            .directory("a", permissions: .defaultDirectory, content: []),
            Self.text("b.txt", "b"),
            .directory("b", permissions: .defaultDirectory, content: [])
        ])
    }

    @Test("Empty collection produces no content")
    func empty() {
        let content = ForEach([] as [String]) { name in
            File(name, text: name)
        }
        #expect(content._serialize() == [])
    }

    @Test("Skipped elements contribute nothing")
    func skipped() {
        let content = ForEach(0 ..< 4) { index in
            if index % 2 == 0 {
                File("\(index).txt", text: "\(index)")
            }
        }
        #expect(content._serialize() == [
            Self.text("0.txt", "0"),
            Self.text("2.txt", "2")
        ])
    }

    @Test("Environment set on the ForEach reaches each file")
    func environment() {
        let content = ForEach(["a", "b"]) { name in
            File(name, fileExtension: "txt") {
                Lines {
                    name
                    name
                }
            }
        }
        .lineSpacing(2)
        #expect(content._serialize() == [
            Self.text("a.txt", "a\n\na"),
            Self.text("b.txt", "b\n\nb")
        ])
    }

    @Test("Nested inside a folder")
    func nested() {
        let content = Folder("root") {
            File("first.txt", text: "first")
            ForEach(1 ... 2) { index in
                File("\(index).txt", text: "\(index)")
            }
            File("last.txt", text: "last")
        }
        #expect(content._serialize() == [
            .directory("root", permissions: .defaultDirectory, content: [
                Self.text("first.txt", "first"),
                Self.text("1.txt", "1"),
                Self.text("2.txt", "2"),
                Self.text("last.txt", "last")
            ])
        ])
    }

}
