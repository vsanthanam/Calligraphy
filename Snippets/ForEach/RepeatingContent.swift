// Repeat a piece of a string for every element in a collection with `ForEach`.

// snippet.hide
import Calligraphy

struct Feature {
    let name: String
}

let features = [
    Feature(name: "String composition"),
    Feature(name: "Directory composition"),
    Feature(name: "Data composition")
]

// snippet.show
// snippet.for-each
let component = Lines {
    "Features:"
    ForEach(features) { feature in
        Line {
            "- "
            feature.name
        }
        .tabbed()
    }
}
// snippet.end

// snippet.hide
print(String(component))
