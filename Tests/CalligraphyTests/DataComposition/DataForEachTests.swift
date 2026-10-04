// Calligraphy
// DataForEachTests.swift
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

@Suite("ForEach Data Tests", .tags(.dataComposition))
struct DataForEachTests {

    @Test("Bytes are concatenated in order")
    func concatenates() {
        let component = ForEach([0x01, 0x02, 0x03] as [UInt8]) { byte in
            byte
        }
        #expect(Data(component) == Data([0x01, 0x02, 0x03]))
    }

    @Test("Each element can produce multiple bytes")
    func multipleBytes() {
        let component = ForEach(["ab", "cd"]) { string in
            Data(string.utf8)
            0x00
        }
        #expect(Data(component) == Data([0x61, 0x62, 0x00, 0x63, 0x64, 0x00]))
    }

    @Test("Empty collection renders nothing")
    func empty() {
        let component = ForEach([] as [UInt8]) { byte in
            byte
        }
        #expect(component.render(in: EnvironmentValues()) == nil)
    }

    @Test("Skipped elements contribute nothing")
    func skipped() {
        let component = ForEach(0 ..< 4) { index in
            if index % 2 == 0 {
                UInt8(index)
            }
        }
        #expect(Data(component) == Data([0x00, 0x02]))
    }

    @Test("Content reads the environment")
    func readsEnvironment() {
        struct ByteReader: DataComponent {
            @Environment(\.forEachTestByte)
            var byte
            var body: some DataComponent {
                byte
            }
        }
        let component = ForEach(0 ..< 2) { _ in
            ByteReader()
        }
        .environment(\.forEachTestByte, 0x09)
        #expect(Data(component) == Data([0x09, 0x09]))
    }

    @Test("Nested inside a data builder")
    func nested() {
        let component = DataComponents {
            0xFF
            ForEach(0 ..< 2) { index in
                UInt8(index)
            }
            0xFE
        }
        #expect(Data(component) == Data([0xFF, 0x00, 0x01, 0xFE]))
    }

}

extension EnvironmentValues {

    @Entry
    fileprivate var forEachTestByte: UInt8 = 0x00

}
