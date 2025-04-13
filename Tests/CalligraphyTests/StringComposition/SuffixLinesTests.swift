//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

@Suite
struct SuffixLinesTests {
    
    @Test
    func stringModifier() {
        let suffixLines = Lines {
            "foo"
            "bar"
            "baz"
        }
        .suffixLines(with: " -")
        
        let expected = #"""
        foo -
        bar -
        baz -
        """#
        
        #expect(suffixLines.build() == expected)
    }
    
    @Test
    func stringBuilder() {
        let suffixLines = Lines {
            "foo"
            "bar"
            "baz"
        }
        .suffixLines {
            Line {
                Space()
                "-"
            }
        }
        
        let expected = #"""
        foo -
        bar -
        baz -
        """#
        
        #expect(suffixLines.build() == expected)
    }
    
}
