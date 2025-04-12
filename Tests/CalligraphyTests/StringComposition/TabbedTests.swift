//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

@Suite
struct TabbedTests {
    
    @Test
    func standard() {
        let tabbed = Tabbed {
            "foo"
            "bar"
            "baz"
        }
        
        let expected = #"""
            foo
            bar
            baz
        """#
        
        #expect(tabbed.build() == expected)
    }
    
    @Test
    func modifier() {
        let tabbed = Lines {
            "foo"
            "bar"
            "baz"
        }
        .tabbed(2)
        
        let expected = #"""
                foo
                bar
                baz
        """#
        
        #expect(tabbed.build() == expected)
    }
    
}
