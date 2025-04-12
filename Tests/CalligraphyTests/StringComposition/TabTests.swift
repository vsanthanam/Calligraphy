//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Calligraphy
import Testing

func tab() {
    let tab = Tab()
    #expect(tab.build() == "    ")
}
