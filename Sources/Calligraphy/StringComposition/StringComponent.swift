// Calligraphy
// StringComponent.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@_typeEraser(AnyStringComponent)
public protocol StringComponent {

    associatedtype Body: StringComponent

    @StringBuilder
    var body: Body { get }

    func render(
        in environment: StringEnvironmentValues
    ) -> String?

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension StringComponent {

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        for child in Mirror(reflecting: self).children {
            (child.value as? (any StringEnvironmentPropertyWrapper))?.inject(environment)
        }
        return body.render(in: environment)
    }

    func fatalErrorImperativeStringComponent(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError(
            """
            StringComponent \(Self.self) does not have a body. Do not invoke this property directly.
            """,
            file: file,
            line: line
        )
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: StringComponent {

    public func render(
        in environment: StringEnvironmentValues
    ) -> String? {
        fatalError()
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<LHS, RHS>> where LHS: StringComponent, RHS: StringComponent {
    Line {
        lhs
        rhs
    }
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<RawStringComponent, RHS>> where LHS: StringProtocol, RHS: StringComponent {
    RawStringComponent(lhs) + rhs
}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public func + <LHS, RHS>(
    lhs: LHS,
    rhs: RHS
) -> Line<StringBuilder._Assembled<LHS, RawStringComponent>> where LHS: StringComponent, RHS: StringProtocol {
    lhs + RawStringComponent(rhs)
}
