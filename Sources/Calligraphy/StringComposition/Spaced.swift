//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/11/25.
//

extension StringComponent {
    
    public func spaced() -> some StringComponent {
        Spaced { self }
    }
    
}

public struct Spaced<T>: StringComponent where T: StringComponent {
    
    public init(
        @StringBuilder components: () -> T
    ) {
        self.components = components()
    }
    
    public var body: some StringComponent {
        components
            .joined(separator: " ")
    }
    
    private let components: T
    
}
