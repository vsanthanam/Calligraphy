// Calligraphy
// JoinedTests.swift
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

@Suite("Joined Tests", .tags(.stringComposition))
struct JoinedTests {

    @Test("Component with String Separator")
    func string() {
        let joined = Joined(separator: ", ") {
            "foo"
            "bar"
            "baz"
        }
        #expect(joined.content == "foo, bar, baz")
    }

    @Test("Component with Builder Separator")
    func builder() {
        let joined = Joined {
            "foo"
            "bar"
            "baz"
        } separator: {
            Line {
                ","
                Space()
            }
        }
        #expect(joined.content == "foo, bar, baz")
    }

    @Test("Modifier with String Separator")
    func stringModifier() {
        let joined = StringComponents {
            "foo"
            "bar"
            "baz"
        }
        .joined(separator: ", ")
        #expect(joined.content == "foo, bar, baz")
    }

    @Test("Modifier with Builder Separator")
    func stringBuilder() {
        let joined = StringComponents {
            "foo"
            "bar"
            "baz"
        }
        .joined {
            Line {
                ","
                Space()
            }
        }
        #expect(joined.content == "foo, bar, baz")
    }

}
