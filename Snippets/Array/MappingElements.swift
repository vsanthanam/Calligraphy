// Embed an array in a `@StringBuilder` by mapping each element to a string component.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.map
let items = ["apple", "banana", "cherry"]

let list = String.build {
    items.map { item in
        "- \(item)"
    }
}
// snippet.end

// snippet.hide
print(list)
