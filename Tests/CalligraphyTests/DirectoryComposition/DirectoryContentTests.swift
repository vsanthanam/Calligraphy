// Calligraphy
// DirectoryContentTests.swift
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

@Suite("Directory Content Tests", .tags(.directoryComposition))
struct DirectoryContentTests {

    @Test("Basic write")
    func basicWrite() async throws {
        let content = Files {
            File("foo.txt") {
                "bar"
                "baz"
            }
            Folder("bar") {
                File("baz.txt") {
                    "qux"
                    "quux"
                }
                File("quuz.txt") {
                    "corge"
                    "grault"
                }
            }
        }
        let directory = FileManager.default.temporaryDirectory
        try await content.write(to: directory, shouldOverwrite: true)
        let fooURL = directory.appending(path: "foo.txt", directoryHint: .notDirectory)
        let fooData = try Data(contentsOf: fooURL)
        let fooString = try #require(String(data: fooData, encoding: .utf8))
        #expect(fooString == "bar\nbaz")
        let barURL = directory.appending(path: "bar", directoryHint: .isDirectory)
        #expect(FileManager.default.fileExists(atPath: barURL.path()))
        let bazURL = barURL.appending(path: "baz.txt", directoryHint: .notDirectory)
        let bazData = try Data(contentsOf: bazURL)
        let bazString = try #require(String(data: bazData, encoding: .utf8))
        #expect(bazString == "qux\nquux")
        let quuzURL = barURL.appending(path: "quuz.txt", directoryHint: .notDirectory)
        let quuzData = try Data(contentsOf: quuzURL)
        let quuzString = try #require(String(data: quuzData, encoding: .utf8))
        #expect(quuzString == "corge\ngrault")
    }

}
