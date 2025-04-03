// Calligraphy
// DataBuilder.swift
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

import Foundation

@resultBuilder
public enum DataBuilder {

    public static func buildExpression(
        _ expression: Data
    ) -> [Data] {
        [expression]
    }

    public static func buildExpression(
        _ expression: [Data]
    ) -> [Data] {
        expression
    }

    public static func buildExpression(
        _ expression: [UInt8]
    ) -> [Data] {
        [Data(expression)]
    }

    public static func buildExpression(
        _ expression: UInt8
    ) -> [Data] {
        [Data([expression])]
    }

    public static func buildBlock() -> [Data] {
        []
    }

    public static func buildBlock(
        _ components: Data...
    ) -> [Data] {
        components
    }

    public static func buildBlock(
        _ components: [Data]...
    ) -> [Data] {
        components
            .flatMap { data in data }
    }

    public static func buildEither(
        first component: [Data]
    ) -> [Data] {
        component
    }

    public static func buildEither(
        second component: [Data]
    ) -> [Data] {
        component
    }

    public static func buildOptional(
        _ component: [Data]?
    ) -> [Data] {
        if let component {
            component
        } else {
            []
        }
    }

    public static func buildArray(
        _ components: [[Data]]
    ) -> [Data] {
        components
            .flatMap { data in data }
    }

    public static func buildLimitedAvailability(
        _ component: [Data]
    ) -> [Data] {
        component
    }

    public static func buildFinalResult(
        _ component: [Data]
    ) -> Data {
        component
            .reduce(Data(), +)
    }

}
