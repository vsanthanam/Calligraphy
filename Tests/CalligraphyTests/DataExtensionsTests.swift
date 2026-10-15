// Calligraphy
// DataExtensionsTests.swift
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
import Foundation
import Testing

@Suite("Data Extensions Tests", .tags(.dataComposition))
struct DataExtensionsTests {

    @Test("Initializer")
    func initializer() {
        let data = Data(RawDataComponent(Data([0x01, 0x02])))
        #expect(data == Data([0x01, 0x02]))
    }

    @Test("Initializer with Empty Component")
    func initializerEmpty() {
        let data = Data(EmptyDataComponent())
        #expect(data == Data())
    }

    @Test("Builder Initializer")
    func builder() {
        let data = Data {
            0x01 as UInt8
            Data([0x02, 0x03])
        }
        #expect(data == Data([0x01, 0x02, 0x03]))
    }

    @Test("Builder Initializer with Empty Block")
    func builderEmpty() {
        let data = Data {}
        #expect(data == Data())
    }

}
