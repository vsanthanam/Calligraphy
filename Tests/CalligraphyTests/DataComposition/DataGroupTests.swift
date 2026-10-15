// Calligraphy
// DataGroupTests.swift
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
import Foundation
import Testing

@Suite("Group Data Tests", .tags(.dataComposition))
struct DataGroupTests {

    @Test("Bytes are concatenated in order")
    func concatenates() {
        let component = Group {
            0x01 as UInt8
            0x02 as UInt8
            0x03 as UInt8
        }
        #expect(Data(component) == Data([0x01, 0x02, 0x03]))
    }

    @Test("Empty group renders nothing")
    func empty() {
        let component = Group {} as Group<EmptyDataComponent>
        #expect(component._render(in: EnvironmentValues()) == nil)
    }

    @Test("Composable with Modifiers")
    func composable() {
        struct ByteReader: DataComponent {
            @Environment(\.byte) var byte
            var body: some DataComponent {
                byte
            }
        }
        let component = Group {
            ByteReader()
            ByteReader()
        }
        .environment(\.byte, 0xAB)
        #expect(Data(component) == Data([0xAB, 0xAB]))
    }

}

extension EnvironmentValues {

    @Entry fileprivate var byte: UInt8 = 0x00

}
