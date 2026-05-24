// Calligraphy
// StringEnvironmentValuesTests.swift
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

@Suite("String Environment Values Tests", .tags(.stringComposition))
struct StringEnvironmentValuesTests {

    private struct CounterKey: StringEnvironmentKey {
        static let defaultValue: Int = 0
    }

    private struct LabelKey: StringEnvironmentKey {
        static let defaultValue: String = ""
    }

    @Test("Subscript Returns Default")
    func subscriptDefault() {
        let values = StringEnvironmentValues()
        #expect(values[CounterKey.self] == 0)
    }

    @Test("Subscript Returns Set Value")
    func subscriptSet() {
        var values = StringEnvironmentValues()
        values[CounterKey.self] = 42
        #expect(values[CounterKey.self] == 42)
    }

    @Test("Distinct Keys Are Independent")
    func distinctKeys() {
        var values = StringEnvironmentValues()
        values[CounterKey.self] = 7
        values[LabelKey.self] = "hello"
        #expect(values[CounterKey.self] == 7)
        #expect(values[LabelKey.self] == "hello")
    }

    @Test("Values Are Copy-on-Write")
    func copyOnWrite() {
        var original = StringEnvironmentValues()
        original[CounterKey.self] = 1
        var copy = original
        copy[CounterKey.self] = 2
        #expect(original[CounterKey.self] == 1)
        #expect(copy[CounterKey.self] == 2)
    }

}
