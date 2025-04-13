//
//  File.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/13/25.
//

import Calligraphy
import Testing

struct FooDirectory: Directory {
    
    let name = "Foo"
    
    var body: some DirectoryComponent {

    }
    
}

@Test
func directoryDefaultSerialization() {

    let fooDirectory = FooDirectory()
    let serialized = fooDirectory._serialize()
    let expected = [SerializedDirectoryContent.directory(.init("Foo", children: fooDirectory.body._serialize()))]
    #expect(serialized == expected)

}
