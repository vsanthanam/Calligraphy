//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum DataComponentBuilder {
    
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
    ) -> _Either<First, Second> where First: DataComponent, Second: DataComponent {
        .first(component)
    }
    
    public static func buildEither<First, Second>(
        second component: Second
    ) -> _Either<First, Second> where First: DataComponent, Second: DataComponent {
        .second(component)
    }
    
    @DataComponentBuilder
    public static func buildOptional<T>(
        _ component: T?
    ) -> _Either<T, _Raw> where T: DataComponent {
        if let component {
            component
        } else {
            Data()
        }
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
        
        init(accumulated: repeat each Accumulated, next: Next) {
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
    
}
