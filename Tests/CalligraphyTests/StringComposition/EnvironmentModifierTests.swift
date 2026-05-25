// Calligraphy
// EnvironmentModifierTests.swift
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

@Suite("Environment Modifier Tests", .tags(.stringComposition))
struct EnvironmentModifierTests {

    private struct CountKey: StringEnvironmentKey {
        static let defaultValue: Int = 0
    }

    @Test("Set by Key")
    func setByKey() {
        let component = ReadEnvironment { environment in
            "\(environment[CountKey.self])"
        }
        .environment(CountKey.self, 5)
        #expect(String(component) == "5")
    }

    @Test("Set by Key Path")
    func setByKeyPath() {
        let component = ReadEnvironment { environment in
            environment.separator
        }
        .environment(\.separator, "|")
        #expect(String(component) == "|")
    }

    @Test("Transform Environment")
    func transform() {
        let component = ReadEnvironment { environment in
            "\(environment.lineSpacing)"
        }
        .transformEnvironment { environment in
            environment.lineSpacing = 3
        }
        #expect(String(component) == "3")
    }

    @Test("Override Only Applies to Descendants")
    func scope() {
        let component = StringComponents {
            ReadEnvironment { environment in
                "first:\(environment.lineSpacing)"
            }
            .environment(\.lineSpacing, 3)
            ReadEnvironment { environment in
                "second:\(environment.lineSpacing)"
            }
        }
        #expect(String(component) == "first:3\nsecond:1")
    }

    @Test("Closest Modifier Wins")
    func closestWins() {
        let component = ReadEnvironment { environment in
            "\(environment.lineSpacing)"
        }
        .environment(\.lineSpacing, 1)
        .environment(\.lineSpacing, 9)
        #expect(String(component) == "1")
    }

}
