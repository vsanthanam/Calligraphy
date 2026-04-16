// Calligraphy
// FileTests.swift
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

@Suite(.tags(.directoryComposition))
struct FileTests {

    @Test
    func `String builder initializer`() {
        let file = File("foo") { "Bar" }
        let contents = file._serialize()
        #expect(contents == [.text("foo", permissions: .defaultFile, text: "Bar", encoding: .utf8)])
    }

    @Test
    func `String builder with extension initializer`() {
        let file = File("foo", fileExtension: "txt") { "Bar" }
        let contents = file._serialize()
        #expect(contents == [.text("foo.txt", permissions: .defaultFile, text: "Bar", encoding: .utf8)])
    }

    @Test
    func `String initializer`() {
        let file = File("foo", text: "Bar")
        let contents = file._serialize()
        #expect(contents == [.text("foo", permissions: .defaultFile, text: "Bar", encoding: .utf8)])
    }

    @Test
    func `String with extension initializer`() {
        let file = File("foo", fileExtension: "txt", text: "Bar")
        let contents = file._serialize()
        #expect(contents == [.text("foo.txt", permissions: .defaultFile, text: "Bar", encoding: .utf8)])
    }

    @Test
    func `Data builder initializer`() {
        let file = File("foo") { Data("Bar".utf8) }
        let contents = file._serialize()
        #expect(contents == [.data("foo", permissions: .defaultFile, data: Data("Bar".utf8))])
    }

    @Test
    func `Data builder with extension initializer`() {
        let file = File("foo", fileExtension: "txt") { Data("Bar".utf8) }
        let contents = file._serialize()
        #expect(contents == [.data("foo.txt", permissions: .defaultFile, data: Data("Bar".utf8))])
    }

    @Test
    func `Data initializer`() {
        let file = File("foo", data: Data("Bar".utf8))
        let contents = file._serialize()
        #expect(contents == [.data("foo", permissions: .defaultFile, data: Data("Bar".utf8))])
    }

    @Test
    func `Data with extension initializer`() {
        let file = File("foo", fileExtension: "txt", data: Data("Bar".utf8))
        let contents = file._serialize()
        #expect(contents == [.data("foo.txt", permissions: .defaultFile, data: Data("Bar".utf8))])
    }

}
