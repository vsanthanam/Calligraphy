// Calligraphy
// EntryTests.swift
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

extension StringEnvironmentValues {

    @StringEntry
    var entryTestGreeting: String = "Hello"

}

@Suite("@StringEntry Tests", .tags(.stringComposition))
struct EntryTests {

    private struct Reader: StringComponent {

        @StringEnvironment(\.entryTestGreeting)
        var greeting: String

        var body: some StringComponent {
            greeting
        }

    }

    @Test("Generated Default Value")
    func defaultValue() {
        #expect(String(Reader()) == "Hello")
    }

    @Test("Generated Accessors Allow Override")
    func override() {
        let component = Reader()
            .environment(\.entryTestGreeting, "Howdy")
        #expect(String(component) == "Howdy")
    }

}
