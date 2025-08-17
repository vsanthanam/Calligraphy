// Calligraphy
// DataBuilderTests.swift
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

@testable import Calligraphy
import Collections
import Foundation
import Testing

@Suite("@DataBuilder Tests", .tags(.stringComposition))
struct DataBuilderTests {

    @Test("Data Expression")
    func data() {

        @DataBuilder
        func builder() -> some DataComponent {
            Data("Foo".utf8)
        }

        let components = builder()
        #expect(components is RawDataComponent)
        #expect(components._data == Data([0x46, 0x6F, 0x6F]))
    }

    @Test("[UInt8] Expression")
    func uInt8Array() {

        @DataBuilder
        func builder() -> some DataComponent {
            [0x46, 0x6F, 0x6F]
        }

        let components = builder()
        #expect(components is RawDataComponent)
        #expect(components._data == Data([0x46, 0x6F, 0x6F]))
    }

    @Test("some Collection<Data> Expression")
    func dataCollection() {

        @DataBuilder
        func builder() -> some DataComponent {
            [Data("Foo".utf8), Data("Foo".utf8)]
        }

        let components = builder()
        #expect(components is RawDataComponent)
        #expect(components._data == Data([0x46, 0x6F, 0x6F, 0x46, 0x6F, 0x6F]))
    }

    @Test("some Collection<UInt8> Expression")
    func uInt8Collection() {

        @DataBuilder
        func builder() -> some DataComponent {
            OrderedSet([0x46, 0x6F, 0x6F])
        }

        let components = builder()
        #expect(components is RawDataComponent)
        #expect(components._data == Data([0x46, 0x6F]))
    }

    @Test("No Components")
    func noComponents() {

        @DataBuilder
        func builder() -> some DataComponent {}

        let components = builder()
        #expect(components is EmptyDataComponent)
        #expect(components._data == nil)
    }

    @Test("One Component")
    func singleComponent() {

        struct Foo: DataComponent {

            var body: some DataComponent {
                [0x46, 0x6F, 0x6F]
            }

        }

        @DataBuilder
        func builder() -> some DataComponent {
            Foo()
        }

        let components = builder()
        #expect(components is Foo)
        #expect(components._data == Data([0x46, 0x6F, 0x6F]))
    }

    @Test("Multiple Components")
    func multipleComponents() {
        struct Foo: DataComponent {

            var body: some DataComponent {
                [0x46, 0x6F, 0x6F]
            }

        }

        struct Bar: DataComponent {

            var body: some DataComponent {
                [0x42, 0x61, 0x72]
            }

        }

        struct Baz: DataComponent {

            var body: some DataComponent {
                [0x42, 0x61, 0x7A]
            }

        }

        @DataBuilder
        func builder() -> some DataComponent {
            Foo()
            Bar()
            Baz()
        }

        let components = builder()
        #expect(components is DataBuilder._Block<Foo, Bar, Baz>)

        let expected = Data([0x46, 0x6F, 0x6F, 0x42, 0x61, 0x72, 0x42, 0x61, 0x7A])
        #expect(components._data == expected)
    }

    @Test(
        "If/Else Support",
        arguments: [(true, Data([0x46, 0x6F, 0x6F])), (false, Data([0x42, 0x61, 0x72]))]
    )
    func ifElse(flow: Bool, result: Data) {

        struct Foo: DataComponent {

            var body: some DataComponent {
                [0x46, 0x6F, 0x6F]
            }

        }

        struct Bar: DataComponent {

            var body: some DataComponent {
                [0x42, 0x61, 0x72]
            }

        }

        @DataBuilder
        func builder() -> some DataComponent {
            if flow {
                Foo()
            } else {
                Bar()
            }
        }

        let components = builder()
        #expect(components is DataBuilder._Either<Foo, Bar>)
        #expect(components._data == result)
    }

    @Test(
        "Single If Support",
        arguments: [(true, Data([0x46, 0x6F, 0x6F, 0x42, 0x61, 0x72])), (false, Data([0x42, 0x61, 0x72]))]
    )
    func singleIf(flow: Bool, result: Data) {

        struct Foo: DataComponent {

            var body: some DataComponent {
                [0x46, 0x6F, 0x6F]
            }

        }

        struct Bar: DataComponent {

            var body: some DataComponent {
                [0x42, 0x61, 0x72]
            }

        }

        @DataBuilder
        func builder() -> some DataComponent {
            if flow {
                Foo()
            }
            Bar()
        }

        let components = builder()
        #expect(components is DataBuilder._Block<DataBuilder._Either<Foo, EmptyDataComponent>, Bar>)
        #expect(components._data == result)
    }
//
//    @Test("For Loop Support")
//    func forLoop() {
//        @StringBuilder
//        func builder() -> some StringComponent {
//            for i in 0 ..< 8 {
//                if i % 2 == 0 {
//                    "\(i + 1)"
//                }
//            }
//        }
//
//        let components = builder()
//        #expect(components is StringBuilder._List<StringBuilder._Either<RawStringComponent, EmptyStringComponent>>)
//
//        let expected = #"""
//        1
//        3
//        5
//        7
//        """#
//        #expect(components._content == expected)
//    }
//
//    @Test("Availablility Check Support")
//    func availabilityCheck() {
//        @StringBuilder
//        func builder() -> some StringComponent {
//            if #available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *) {
//                "foo"
//            }
//        }
//
//        let components = builder()
//        #expect(components is StringBuilder._Either<AnyStringComponent, EmptyStringComponent>)
//        #expect(components._content == "foo")
//    }
//
//    @Test("+ Operators")
//    func operators() {
//
//        struct Foo: StringComponent {
//
//            var body: some StringComponent {
//                "foo"
//            }
//
//        }
//
//        struct Bar: StringComponent {
//
//            var body: some StringComponent {
//                "bar"
//            }
//
//        }
//
//        struct Empty: StringComponent {
//
//            var body: some StringComponent {}
//
//        }
//
//        let foo = Foo()
//        let bar = Bar()
//        let empty = Empty()
//
//        #expect((foo + bar)._content == "foobar")
//        #expect(("foo" + bar)._content == "foobar")
//        #expect((foo + "bar")._content == "foobar")
//        #expect((foo + empty)._content == "foo")
//        #expect((empty + bar)._content == "bar")
//        #expect((empty + empty)._content == nil)
//    }

}
