//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 9/27/25.
//

public struct Empty: StringComponent {
    
    public init() {}
    
    public let  _content: String? = ""
    
    public var body: some StringComponent {
        fatalErrorImperativeStringComponent()
    }
    
}
