// Calligraphy
// GroupTests.swift
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
import Testing

@Suite("Group Tests", .tags(.stringComposition))
struct GroupTests {

    @Test("Single Component")
    func single() {
        let components = Group {
            "foo"
        }
        #expect(String(components) == "foo")
    }

    @Test("Multiple Components")
    func multiple() {
        let components = Group {
            "foo"
            "bar"
            "baz"
        }
        #expect(String(components) == """
        foo
        bar
        baz
        """)
    }

    @Test("Empty")
    func empty() {
        let components = Group {}
        #expect(String(components) == "")
    }

    @Test("Composable with Modifiers")
    func composable() {
        let components = Group {
            "foo"
            "bar"
        }
        .joined(separator: ", ")
        #expect(String(components) == "foo, bar")
    }

    @Test("Transparent to Surrounding Separator")
    func transparent() {
        let components = Line {
            "foo"
            Group {
                "bar"
                "baz"
            }
        }
        #expect(String(components) == "foobarbaz")
    }

    @Test("Body Exposes Grouped Content")
    func body() {
        let components = Group {
            "foo"
        }
        #expect(String(components.body) == "foo")
    }

}
