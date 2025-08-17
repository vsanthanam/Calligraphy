//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 8/17/25.
//

public struct Empty: StringComponent {
    
    // MARK: - Initializers
    
    public init() {}
    
    // MARK: - StringComponent
    
    public var body: some StringComponent {
        ""
    }
    
}
