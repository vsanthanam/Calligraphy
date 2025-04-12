//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

@Test
func rawStringComponent() {
    let rawStringComponent = RawStringComponent("Hello World")
    #expect(rawStringComponent.build() == "Hello World")
}
