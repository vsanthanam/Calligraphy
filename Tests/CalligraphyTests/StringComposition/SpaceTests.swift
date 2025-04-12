//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

func space() {
    let space = Space()
    #expect(space.build() == " ")
}
