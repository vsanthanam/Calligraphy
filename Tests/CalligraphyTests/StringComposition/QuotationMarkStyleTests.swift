// Calligraphy
// QuotationMarkStyleTests.swift
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

@Suite("Quotation Mark Style Tests", .tags(.stringComposition))
struct QuotationMarkStyleTests {

    @Test("Single Raw Value")
    func single() {
        #expect(QuotationMarkStyle.single.rawValue == "'")
    }

    @Test("Double Raw Value")
    func double() {
        #expect(QuotationMarkStyle.double.rawValue == "\"")
    }

    @Test("Triple Single Raw Value")
    func tripleSingle() {
        #expect(QuotationMarkStyle.tripleSingle.rawValue == "'''")
    }

    @Test("Triple Double Raw Value")
    func tripleDouble() {
        #expect(QuotationMarkStyle.tripleDouble.rawValue == "\"\"\"")
    }

    @Test("Default Style")
    func defaultStyle() {
        #expect(QuotationMarkStyle.default == .double)
    }

    @Test("Environment Default")
    func environmentDefault() {
        let mark = QuotationMark()
        #expect(String(mark) == QuotationMarkStyle.default.rawValue)
    }

}
