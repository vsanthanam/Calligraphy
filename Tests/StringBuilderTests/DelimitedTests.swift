// Calligraphy
// DelimitedTests.swift
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

import Foundation
@testable import StringBuilder
import Testing

@Suite("Delimited Tests")
struct DelimitedTests {

    @Test("Modifier with String Delimiter")
    func modifierString() async throws {

        let delimited = StringComponents {
            "foo"
            "bar"
            "baz"
        }
        .delimited(by: "|")
        .joined(separator: "-")

        let expected = """
        |foo-bar-baz|
        """

        #expect(delimited._content == expected)
    }

    @Test("Modifier with Builder Delimiter")
    func modifierBuilder() async throws {

        let delimited = StringComponents {
            "foo"
            "bar"
            "baz"
        }
        .delimited {
            "?"
        }
        .joined(separator: "%")

        let expected = """
        ?foo%bar%baz?
        """

        #expect(delimited._content == expected)
    }

    @Test("Component with String Delimiter")
    func string() async throws {

        let delimited = Delimited(by: "|") {
            "foo"
            "bar"
            "baz"
        }
        .joined(separator: "-")

        let expected = """
        |foo-bar-baz|
        """

        #expect(delimited._content == expected)
    }

    @Test("Component with Builder Delimiter")
    func builder() async throws {

        let delimited = Delimited {
            "foo"
            "bar"
            "baz"
        } delimiter: {
            "!!!"
        }

        let expected = """
        !!!foo
        bar
        baz!!!
        """

        #expect(delimited._content == expected)
    }

    @Test("Empty delimited content")
    func emptyContent() async throws {

        let delimited = Delimited {} delimiter: {
            "!!!"
        }

        #expect(delimited._content == nil)
    }

    @Test("Content with empty delimiter")
    func emptyDelimiter() async throws {

        let delimited = Delimited {
            "foo"
            "bar"
            "baz"
        } delimiter: {}
            .joined(separator: ", ")

        #expect(delimited._content == "foo, bar, baz")
    }

}
