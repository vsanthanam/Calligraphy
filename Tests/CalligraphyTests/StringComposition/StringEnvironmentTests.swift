// Calligraphy
// StringEnvironmentTests.swift
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

@Suite("@StringEnvironment Tests", .tags(.stringComposition))
struct StringEnvironmentTests {

    private struct GreetingKey: StringEnvironmentKey {
        static let defaultValue: String = "Hello"
    }

    private struct ReaderByKey: StringComponent {

        @StringEnvironment(GreetingKey.self)
        var greeting: String

        var body: some StringComponent {
            greeting
        }

    }

    private struct ReaderByKeyPath: StringComponent {

        @StringEnvironment(\.separator)
        var separator: String

        var body: some StringComponent {
            separator
        }

    }

    @Test("Reads Default via Key")
    func readDefaultByKey() {
        #expect(String(ReaderByKey()) == "Hello")
    }

    @Test("Reads Default via Key Path")
    func readDefaultByKeyPath() {
        #expect(String(ReaderByKeyPath()) == "\n")
    }

    @Test("Reads Injected Value via Key")
    func readInjectedByKey() {
        let component = ReaderByKey()
            .environment(GreetingKey.self, "Howdy")
        #expect(String(component) == "Howdy")
    }

    @Test("Reads Injected Value via Key Path")
    func readInjectedByKeyPath() {
        let component = ReaderByKeyPath()
            .environment(\.separator, "|")
        #expect(String(component) == "|")
    }

}
