// Calligraphy
// ModifiedDataTests.swift
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

extension EnvironmentValues {

    @Entry
    var modifiedDataTestByte: UInt8 = 0xFF

}

@Suite("ModifiedData Tests", .tags(.dataComposition))
struct ModifiedDataTests {

    @Test("Modifier body composes around the content")
    func composes() {
        let component = RawDataComponent(Data([0x01, 0x02]))
            .modifier(NullTerminated())

        #expect(Data(component) == Data([0x01, 0x02, 0x00]))
    }

    @Test("Initializer matches the modifier method")
    func initializer() {
        let content = RawDataComponent(Data([0x01, 0x02]))
        let component = ModifiedData(
            content: content,
            modifier: NullTerminated()
        )

        #expect(Data(component) == Data(content.modifier(NullTerminated())))
    }

    @Test("Modifiers chain innermost first")
    func chaining() {
        let component = RawDataComponent(Data([0x01]))
            .modifier(Prefixed(byte: 0xA0))
            .modifier(Prefixed(byte: 0xB0))

        #expect(Data(component) == Data([0xB0, 0xA0, 0x01]))
    }

    @Test("Modifiers read the surrounding environment")
    func readsEnvironment() {
        let component = RawDataComponent(Data([0x01]))
            .modifier(ByteReport())
            .environment(\.modifiedDataTestByte, 0x07)

        #expect(Data(component) == Data([0x01, 0x07]))
    }

    @Test("Environment set in the modifier body reaches the content")
    func environmentFlowsToContent() {
        let component = ByteReader()
            .modifier(SetByte(byte: 0x09))

        #expect(Data(component) == Data([0x09]))
    }

    @Test("Modifier body can skip the content")
    func skipsContent() {
        let component = DataComponents {
            0x01
            RawDataComponent(Data([0x02]))
                .modifier(Hidden())
            0x03
        }

        #expect(Data(component) == Data([0x01, 0x03]))
    }

    @Test("Primitive modifier renders directly")
    func primitive() {
        let component = RawDataComponent(Data([0x01, 0x02, 0x03]))
            .modifier(Reversed())

        #expect(Data(component) == Data([0x03, 0x02, 0x01]))
    }

    @Test("Primitive modifier reads the surrounding environment")
    func primitiveReadsEnvironment() {
        let component = RawDataComponent(Data([0x01]))
            .modifier(ByteSuffix())
            .environment(\.modifiedDataTestByte, 0x07)

        #expect(Data(component) == Data([0x01, 0x07]))
    }

    @Test("Convenience extension returning an opaque type")
    func convenience() {
        let component = RawDataComponent(Data([0x01, 0x02]))
            .nullTerminated()

        #expect(Data(component) == Data([0x01, 0x02, 0x00]))
    }

}

private struct NullTerminated: DataModifier {

    func body(content: Content) -> some DataComponent {
        content
        0x00
    }

}

private struct Prefixed: DataModifier {

    let byte: UInt8

    func body(content: Content) -> some DataComponent {
        byte
        content
    }

}

private struct ByteReport: DataModifier {

    @Environment(\.modifiedDataTestByte)
    private var byte

    func body(content: Content) -> some DataComponent {
        content
        byte
    }

}

private struct ByteReader: DataComponent {

    @Environment(\.modifiedDataTestByte)
    private var byte

    var body: some DataComponent {
        byte
    }

}

private struct SetByte: DataModifier {

    let byte: UInt8

    func body(content: Content) -> some DataComponent {
        content
            .environment(\.modifiedDataTestByte, byte)
    }

}

private struct Hidden: DataModifier {

    func body(content: Content) -> some DataComponent {
        if false {
            content
        }
    }

}

private struct Reversed: DataModifier {

    func body(content: Content) -> Never {
        fatalError()
    }

    func render(content: Content, in environment: EnvironmentValues) -> Data? {
        content._render(in: environment).map { Data($0.reversed()) }
    }

}

private struct ByteSuffix: DataModifier {

    @Environment(\.modifiedDataTestByte)
    private var byte

    func body(content: Content) -> Never {
        fatalError()
    }

    func render(content: Content, in environment: EnvironmentValues) -> Data? {
        (content._render(in: environment) ?? Data()) + Data([byte])
    }

}

extension DataComponent {

    fileprivate func nullTerminated() -> some DataComponent {
        modifier(NullTerminated())
    }

}
