# ``Calligraphy/Directory``

You can implement a directory imperatively, or declaratively.

To implement declaratively, implement the ``contents`` property:

```swift
struct MyDirectory: Directory {

     var contents: [SerializedDirectoryContent] {
        // return a serialized representation of the directory's contents
     }

}
```

To implement declaratively, implement the ``body`` property:

```swift
struct MyDirectory: Directory {

    var body: some DirectoryContent {
        // use DirectoryContentBuilder to declaratively describe the directory's contents
    }

}
```

You shouldn't implement both properties; the opposing property will be implemented for you automatically through a library-provided protocol extension.
If you implement both properties, the library will favor the `content` property over the `body` property.
