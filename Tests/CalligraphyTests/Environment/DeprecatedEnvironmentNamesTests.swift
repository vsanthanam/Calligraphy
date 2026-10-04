// Calligraphy
// DeprecatedEnvironmentNamesTests.swift
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

// This file intentionally uses the deprecated spellings to verify they still compile and behave.

@available(*, deprecated)
private struct LegacyKey: StringEnvironmentKey {
    static let defaultValue: String = "legacy"
}

@available(*, deprecated)
extension StringEnvironmentValues {

    @StringEntry
    var legacyEntry: Int = 7

}

@available(*, deprecated)
private struct LegacyReader: StringComponent {

    @StringEnvironment(LegacyKey.self)
    var keyed: String

    @StringEnvironment(\.legacyEntry)
    var entry: Int

    var body: some StringComponent {
        keyed + ":" + String(entry)
    }

}

@Suite("Deprecated Environment Names", .tags(.environment))
struct DeprecatedEnvironmentNamesTests {

    @Test("Deprecated names compile and resolve")
    @available(*, deprecated)
    func deprecatedNames() {
        #expect(String(LegacyReader()) == "legacy:7")
        let modified = LegacyReader()
            .environment(LegacyKey.self, "new")
            .environment(\.legacyEntry, 8)
        #expect(String(modified) == "new:8")
    }

}
