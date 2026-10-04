// Calligraphy
// ForEachTests.swift
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

@Suite("ForEach Tests", .tags(.stringComposition))
struct ForEachTests {

    @Test("Components")
    func components() {
        let component = ForEach([Foo(value: "a"), Foo(value: "b"), Foo(value: "c")]) { foo in
            foo
        }
        #expect(String(component) == """
        a
        b
        c
        """)
    }

    @Test("Strings")
    func strings() {
        let component = ForEach(["foo", "bar"]) { string in
            string
        }
        #expect(String(component) == """
        foo
        bar
        """)
    }

    @Test("Range")
    func range() {
        let component = ForEach(0 ..< 3) { index in
            "\(index)"
        }
        #expect(String(component) == """
        0
        1
        2
        """)
    }

    @Test("Empty Collection")
    func empty() {
        let component = ForEach([String]()) { string in
            string
        }
        #expect(String(component) == "")
    }

    @Test("Skipped Elements")
    func skipped() {
        let component = ForEach([1, 2, 3, 4]) { number in
            if number.isMultiple(of: 2) {
                "\(number)"
            }
        }
        #expect(String(component) == """
        2
        4
        """)
    }

    @Test("Branches With Different Types")
    func branches() {
        let component = ForEach([true, false, true]) { flag in
            if flag {
                Foo(value: "foo")
            } else {
                "bar"
            }
        }
        #expect(String(component) == """
        foo
        bar
        foo
        """)
    }

    @Test("Modifiers Inside the Content")
    func modifiers() {
        let component = Lines {
            "items:"
            ForEach(["foo", "bar"]) { item in
                Lines {
                    item
                }
                .tabbed()
            }
        }
        .tabDefinition(.spaces(4))
        #expect(String(component) == """
        items:
            foo
            bar
        """)
    }

    @Test("Transparent to the Surrounding Separator")
    func separator() {
        let lines = Lines {
            "foo"
            ForEach(["bar", "baz"]) { item in
                item
            }
        }
        #expect(String(lines) == """
        foo
        bar
        baz
        """)

        let line = Line {
            "foo"
            ForEach(["bar", "baz"]) { item in
                item
            }
        }
        #expect(String(line) == "foobarbaz")

        let joined = StringGroup {
            "foo"
            ForEach(["bar", "baz"]) { item in
                item
            }
        }
        .joined(separator: ", ")
        #expect(String(joined) == "foo, bar, baz")
    }

    @Test("Nested")
    func nested() {
        let component = ForEach(["a", "b"]) { outer in
            ForEach(["1", "2"]) { inner in
                outer + inner
            }
        }
        #expect(String(component) == """
        a1
        a2
        b1
        b2
        """)
    }

    @Test("Content Reads the Environment")
    func environment() {
        let component = ForEach(["foo", "bar"]) { item in
            Quote {
                item
            }
        }
        .quotationMarkStyle(.single)
        #expect(String(component) == """
        'foo'
        'bar'
        """)
    }

    private struct Foo: StringComponent {

        let value: String

        var body: some StringComponent {
            value
        }

    }

}
