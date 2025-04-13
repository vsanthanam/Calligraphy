// Calligraphy
// StringBuilderTests.swift
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
import Testing

@Suite
struct StringBuilderTests {

    @Test
    func string() {

        @StringBuilder
        func builder() -> some StringComponent {
            "foo"
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(components.build() == "foo")
    }

    @Test
    func stringProtocol() {
        let substring = "foo" as Substring

        @StringBuilder
        func builder() -> some StringComponent {
            substring
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(components.build() == "foo")
    }

    @Test
    func customStringConvertible() {

        struct Foo: CustomStringConvertible {
            let description: String = "bar"
        }

        @StringBuilder
        func builder() -> some StringComponent {
            Foo()
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(components.build() == "bar")
    }

    @Test
    func rawRepresentable() {

        enum Foo: String {
            case bar
        }

        @StringBuilder
        func builder() -> some StringComponent {
            Foo.bar
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(components.build() == "bar")
    }

    @Test
    func singleComponent() {

        struct Foo: StringComponent {

            var body: some StringComponent {
                "bar"
            }

        }

        @StringBuilder
        func builder() -> some StringComponent {
            Foo()
        }

        let components = builder()
        #expect(components is Foo)
        #expect(components.build() == "bar")
    }

    @Test
    func multipleComponents() {
        struct Foo: StringComponent {

            var body: some StringComponent {
                "bar"
            }
        }

        struct Bar: StringComponent {

            let content: String? = nil
        }

        struct Baz: StringComponent {

            var body: some StringComponent {
                "foo"
            }
        }

        @StringBuilder
        func builder() -> some StringComponent {
            Foo()
            Bar()
            Baz()
        }

        let components = builder()
        #expect(components is StringBuilder._Block<Foo, Bar, Baz>)

        let expected = #"""
        bar
        foo
        """#
        #expect(components.build() == expected)
    }

    @Test(arguments: [(true, "bar"), (false, "foo")])
    func testIfElse(flow: Bool, result: String) {

        struct Foo: StringComponent {

            var body: some StringComponent {
                "bar"
            }
        }

        struct Bar: StringComponent {

            var body: some StringComponent {
                "foo"
            }

        }

        @StringBuilder
        func builder() -> some StringComponent {
            if flow {
                Foo()
            } else {
                Bar()
            }
        }

        let components = builder()
        #expect(components is StringBuilder._Either<Foo, Bar>)
        #expect(components.build() == result)
    }

    @Test(arguments: [(true, "bar\nfoo"), (false, "foo")])
    func singleIf(flow: Bool, result: String) {

        struct Foo: StringComponent {

            var body: some StringComponent {
                "bar"
            }

        }

        struct Bar: StringComponent {

            var body: some StringComponent {
                "foo"
            }

        }

        @StringBuilder
        func builder() -> some StringComponent {
            if flow {
                Foo()
            }
            Bar()
        }

        let components = builder()
        #expect(components is StringBuilder._Block<StringBuilder._Either<Foo, StringBuilder._Skip>, Bar>)
        #expect(components.build() == result)
    }

    @Test
    func forLoop() {
        @StringBuilder
        func builder() -> some StringComponent {
            for i in 0 ..< 8 {
                if i % 2 == 0 {
                    "\(i + 1)"
                }
            }
        }

        let components = builder()
        #expect(components is StringBuilder._List<StringBuilder._Either<RawStringComponent, StringBuilder._Skip>>)

        let expected = #"""
        1
        3
        5
        7
        """#
        #expect(components.build() == expected)
    }

    @Test
    func availabilityCheck() {
        @StringBuilder
        func builder() -> some StringComponent {
            if #available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *) {
                "foo"
            }
        }

        let components = builder()
        #expect(components is StringBuilder._Either<AnyStringComponent, StringBuilder._Skip>)
        #expect(components.build() == "foo")
    }

}
