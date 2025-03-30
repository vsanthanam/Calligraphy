# ``Calligraphy/DirectoryContent``

A `DirectoryContent` represents one more more entries inside a directory, either files or additional directories.
You will rarely need to interact with this protocol outside of using it as an opaque return type for a ``DirectoryContentBuilder`` result builder.

- Important: You shouldn't implement this protocol directly. Instead, implement either ``Directory`` or ``File``
