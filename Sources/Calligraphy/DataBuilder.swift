//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation

public protocol DataComponent: Sendable {
    
    associatedtype Body: DataComponent = Never
    
    var data: Data { get }
    
    @DataBuilder
    var body: Body { get }
    
}

public extension DataComponent {
    
    var data: Data {
        body.data
    }

    var body: Body {
        fatalError()
    }
}

extension Never: DataComponent {}

@resultBuilder
public enum DataBuilder {
    
    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: DataComponent {
        expression
    }
    
    public static func buildExpression(
        _ expression: Data
    ) -> _Raw {
        _Raw(expression)
    }
    
    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: DataComponent {
        first
    }
    
    public static func buildPartialBlock<each Accumulated, Next>(
        accumulated: repeat each Accumulated,
        next: Next
    ) -> _Accumulate<repeat each Accumulated, Next> where repeat each Accumulated: DataComponent, Next: DataComponent {
        _Accumulate(
            accumulated: repeat each accumulated,
            next: next
        )
    }
    
    public static func buildEither<First, Second>(
        first component: First
    ) -> _Either<First, Second> {
        .first(component)
    }
    
    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> {
        .second(component)
    }
    
    @DataBuilder
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, _Raw> {
        if let component {
            component
        } else {
            Data()
        }
    }
    
    public static func buildArray<T>(
        _ components: [T]
    ) -> _List<T> where T: DataComponent {
        _List(components)
    }
    
    public static func buildLimitedAvailability(
        _ component: some DataComponent
    ) -> AnyDataComponent {
        AnyDataComponent(component)
    }
    
    public enum _Either<First, Second>: DataComponent where First: DataComponent, Second: DataComponent {
        
        case first(First)

        case second(Second)
        
        public var data: Data {
            switch self {
            case let .first(component):
                component.data
            case let .second(component):
                component.data
            }
        }

    }
    
    public struct _Raw: DataComponent {
        
        init(_ data: Data) {
            self.data = data
        }
        
        public let data: Data
        
    }
    
    public struct _Accumulate<each Accumulated, Next>: DataComponent where repeat each Accumulated: DataComponent, Next: DataComponent {
        
        init(
            accumulated: repeat each Accumulated,
            next: Next
        ) {
            self.accumulated = (repeat (each accumulated))
            self.next = next
        }
        
        public var data: Data {
            var rv = Data()
            for component in repeat each accumulated {
                rv += component.data
            }
            rv += next.data
            return rv
        }
        
        private let accumulated: (repeat (each Accumulated))
        private let next: Next
        
    }
    
    public struct _List<Element>: DataComponent where Element: DataComponent {
        
        init(_ list: [Element]) {
            self.list = list
        }
        
        public var data: Data {
            list
                .map(\.data)
                .reduce(into: Data(), +=)
        }
        
        private let list: [Element]
        
    }
    
}

public struct AnyDataComponent: DataComponent {
    
    public init(_ dataComponent: some DataComponent) {
        self._data = { dataComponent.data }
    }
    
    public var data: Data {
        _data()
    }
    
    private let _data: @Sendable () -> Data
    
}
