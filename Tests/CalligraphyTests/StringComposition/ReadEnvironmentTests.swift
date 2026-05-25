// Calligraphy
// ReadEnvironmentTests.swift
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

@Suite("Read Environment Tests", .tags(.stringComposition))
struct ReadEnvironmentTests {

    @Test("Reads Default Environment")
    func readDefault() {
        let component = ReadEnvironment { environment in
            environment.separator
        }
        #expect(String(component) == "\n")
    }

    @Test("Reads Injected Environment")
    func readInjected() {
        let component = ReadEnvironment { environment in
            "\(environment.lineSpacing)"
        }
        .environment(\.lineSpacing, 5)
        #expect(String(component) == "5")
    }

    @Test("Branches on Environment Value")
    func conditionalBody() {
        let component = ReadEnvironment { environment in
            if environment.lineSpacing == 1 {
                "default"
            } else {
                "spaced"
            }
        }
        #expect(String(component) == "default")
        #expect(String(component.environment(\.lineSpacing, 3)) == "spaced")
    }

}
