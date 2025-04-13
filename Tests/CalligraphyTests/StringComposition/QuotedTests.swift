//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

@Suite
struct QuotedTests {
    
    @Test
    func standard() {
        let quoted = Quoted {
            Lines {
                "foo"
                "bar"
                "baz"
            }
        }
        
        let expected = #"""
        "foo
        bar
        baz"
        """#
        
        #expect(quoted.build() == expected)
    }
    
    @Test
    func modifier() {
        let quoted = Lines {
            "foo"
            "bar"
            "baz"
        }
        .quoted(.triple)
        
        let expected = #"""
        '''foo
        bar
        baz'''
        """#
        
        #expect(quoted.build() == expected)
    }

    
}
