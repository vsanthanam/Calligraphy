// Calligraphy
// DirectoryGroupTests.swift
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

@Suite("Group Directory Tests", .tags(.directoryComposition))
struct DirectoryGroupTests {

    private static func text(_ name: String, _ text: String) -> SerializedDirectoryContent {
        .text(name, permissions: .defaultFile, text: text, encoding: .utf8)
    }

    @Test("Entries are listed in order")
    func entries() {
        let content = Group {
            File("a", fileExtension: "txt", text: "a")
            Folder("b") {}
            File("c", fileExtension: "txt", text: "c")
        }
        #expect(content._serialize() == [
            Self.text("a.txt", "a"),
            .directory("b", permissions: .defaultDirectory, content: []),
            Self.text("c.txt", "c")
        ])
    }

    @Test("Empty group produces no content")
    func empty() {
        let content = Group {} as Group<EmptyDirectoryContent>
        #expect(content._serialize() == [])
    }

    @Test("Composable with Modifiers")
    func composable() {
        let content = Group {
            File("a", fileExtension: "txt") {
                Lines {
                    "a"
                    "a"
                }
            }
        }
        .lineSpacing(2)
        #expect(content._serialize() == [
            Self.text("a.txt", "a\n\na")
        ])
    }

    @Test("Nested inside a folder")
    func nested() {
        let content = Folder("root") {
            Group {
                File("a", fileExtension: "txt", text: "a")
                File("b", fileExtension: "txt", text: "b")
            }
        }
        #expect(content._serialize() == [
            .directory("root", permissions: .defaultDirectory, content: [
                Self.text("a.txt", "a"),
                Self.text("b.txt", "b")
            ])
        ])
    }

}
