//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 9/28/25.
//

import XCTest
@testable import CalligraphyCompilerPlugin

final class CalligraphyCompilerPluginTests: XCTestCase {
    
    func test_plugins() {
        let plugin = CalligraphyCompilerPlugin()
        XCTAssert(plugin.providingMacros[0] == FilePermissionsOctalMacro.self)
        XCTAssert(plugin.providingMacros[1] == FilePermissionsStringMacro.self)
    }
    
}
