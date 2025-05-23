// Calligraphy
// SerializedDirectoryContentTests.swift
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

import Calligraphy
import Foundation
import Testing

@Suite("Serialized Directory Content Tests", .tags(.dataComposition))
struct SerializedDirectoryContentTests {

    @Test("Directory Name")
    func directoryName() {
        let directory = SerializedDirectoryContent.directory(
            "Foo",
            permissions: .defaultDirectory,
            content: []
        )
        #expect(directory.name == "Foo")
    }

    @Test("File Name")
    func fileName() {
        let file = SerializedDirectoryContent.text(
            "Foo",
            permissions: .defaultFile,
            text: "Hello, World!",
            encoding: .utf8
        )
        #expect(file.name == "Foo")
    }

    @Test("Codable Support")
    func codableSupport() throws {
        let file = SerializedDirectoryContent.text(
            "Foo",
            permissions: .defaultFile,
            text: "Hello, World!",
            encoding: .utf8
        )
        let data = try JSONEncoder().encode(file)
        let decoded = try JSONDecoder().decode(SerializedDirectoryContent.self, from: data)
        #expect(file == decoded)
    }

}
