// Calligraphy
// StringBuilderTests.swift
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
import Testing

@Suite("@StringBuilder Tests", .tags(.stringComposition))
struct StringBuilderTests {

    @Test("String Expression")
    func string() {

        @StringBuilder
        func builder() -> some StringComponent {
            "foo"
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(String(components) == "foo")
    }

    @Test("some StringProtocol Expression")
    func stringProtocol() {
        let substring = "foo" as Substring

        @StringBuilder
        func builder() -> some StringComponent {
            substring
        }

        let components = builder()
        #expect(components is RawStringComponent)
        #expect(String(components) == "foo")
    }

    @Test("some RawRepresentable Expression")
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
        #expect(String(components) == "bar")
    }

    @Test("No Components")
    func noComponents() {

        @StringBuilder
        func builder() -> some StringComponent {}

        let components = builder()
        #expect(components is StringBuilder._Skip)
        #expect(String(components) == "")
    }

    @Test("One Component")
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
        #expect(String(components) == "bar")
    }

    @Test("Multiple Components")
    func multipleComponents() {
        struct Foo: StringComponent {

            var body: some StringComponent {
                "bar"
            }
        }

        struct Bar: StringComponent {

            func render(in environment: StringEnvironmentValues) -> String? {
                nil
            }

            var body: Never {
                fatalErrorImperativeStringComponent()
            }
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
        #expect(components is StringBuilder._Assembled<Foo, Bar, Baz>)

        let expected = #"""
        bar
        foo
        """#
        #expect(String(components) == expected)
    }

    @Test(
        "If/Else Support",
        arguments: [(true, "bar"), (false, "foo")]
    )
    func ifElse(flow: Bool, result: String) {

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
        #expect(String(components) == result)
    }

    @Test(
        "Single If Support",
        arguments: [(true, "bar\nfoo"), (false, "foo")]
    )
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
        #expect(components is StringBuilder._Assembled<StringBuilder._Either<Foo, StringBuilder._Skip>, Bar>)
        #expect(String(components) == result)
    }

    @Test("For Loop Support")
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
        #expect(String(components) == expected)
    }

    @Test("Availablility Check Support")
    func availabilityCheck() {
        @StringBuilder
        func builder() -> some StringComponent {
            if #available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *) {
                "foo"
            }
        }

        let components = builder()
        #expect(components is StringBuilder._Either<AnyStringComponent, StringBuilder._Skip>)
        #expect(String(components) == "foo")
    }

    @Test("[StringComponent] Array Expression")
    func stringComponentArray() {

        struct Foo: StringComponent {

            var body: some StringComponent {
                "foo"
            }

        }

        @StringBuilder
        func builder() -> some StringComponent {
            [Foo(), Foo(), Foo()]
        }

        let components = builder()
        #expect(components is StringBuilder._List<Foo>)

        let expected = #"""
        foo
        foo
        foo
        """#
        #expect(String(components) == expected)
    }

    @Test("[StringProtocol] Array Expression")
    func stringProtocolArray() {

        @StringBuilder
        func builder() -> some StringComponent {
            ["foo", "bar", "baz"] as [String]
        }

        let components = builder()
        #expect(components is StringBuilder._List<RawStringComponent>)

        let expected = #"""
        foo
        bar
        baz
        """#
        #expect(String(components) == expected)
    }

    @Test("[RawRepresentable] Array Expression")
    func rawRepresentableArray() {

        enum Foo: String {
            case bar
            case baz
        }

        @StringBuilder
        func builder() -> some StringComponent {
            [Foo.bar, Foo.baz]
        }

        let components = builder()
        #expect(components is StringBuilder._List<RawStringComponent>)
        #expect(String(components) == "bar\nbaz")
    }

    @Test("Array.map Support")
    func arrayMap() {

        // Demonstrates builder syntax (if/else) inside the @StringBuilder closure,
        // which requires the custom @StringBuilder map overload since the two branches
        // return different StringComponent types.
        struct Foo: StringComponent {

            var body: some StringComponent {
                "foo"
            }

        }

        struct Bar: StringComponent {

            var body: some StringComponent {
                "bar"
            }

        }

        let flags = [true, false, true]

        @StringBuilder
        func builder() -> some StringComponent {
            flags.map { flag in
                if flag {
                    Foo()
                } else {
                    Bar()
                }
            }
        }

        let components = builder()
        let expected = "foo\nbar\nfoo"
        #expect(String(components) == expected)
    }

    @Test("Array.map as @StringBuilder Expression")
    func arrayMapExpression() {

        struct Foo: StringComponent {

            let value: String

            var body: some StringComponent {
                value
            }

        }

        let items = [Foo(value: "a"), Foo(value: "b"), Foo(value: "c")]

        @StringBuilder
        func builder() -> some StringComponent {
            items.map(\.self)
        }

        let components = builder()
        #expect(String(components) == "a\nb\nc")
    }

    @Test("String Final Result")
    func stringFinalResult() {

        @StringBuilder
        func builder() -> String {
            "foo"
            "bar"
        }

        #expect(builder() == "foo\nbar")
    }

    @Test("String Final Result - Single Component")
    func stringFinalResultSingle() {

        @StringBuilder
        func builder() -> String {
            "foo"
        }

        #expect(builder() == "foo")
    }

    @Test("String Final Result - No Components")
    func stringFinalResultEmpty() {

        @StringBuilder
        func builder() -> String {}

        #expect(builder() == "")
    }

    @Test("String Final Result - Conditional")
    func stringFinalResultConditional() {

        @StringBuilder
        func builder(_ flag: Bool) -> String {
            "foo"
            if flag {
                "bar"
            }
        }

        #expect(builder(true) == "foo\nbar")
        #expect(builder(false) == "foo")
    }

    @Test("+ Operators")
    func operators() {

        struct Foo: StringComponent {

            var body: some StringComponent {
                "foo"
            }

        }

        struct Bar: StringComponent {

            var body: some StringComponent {
                "bar"
            }

        }

        struct Empty: StringComponent {

            var body: some StringComponent {}

        }

        let foo = Foo()
        let bar = Bar()
        let empty = Empty()

        #expect(String(foo + bar) == "foobar")
        #expect(String("foo" + bar) == "foobar")
        #expect(String(foo + "bar") == "foobar")
        #expect(String(foo + empty) == "foo")
        #expect(String(empty + bar) == "bar")
        #expect(String(empty + empty) == "")
    }

}
