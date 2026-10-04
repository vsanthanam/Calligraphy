// Concatenate components edge-to-edge on a single line with `Line`.

// snippet.hide
import Calligraphy

let name = "World"

// snippet.show
// snippet.line
let component = Line {
    "Hello, "
    name
    "!"
}
// snippet.end

// snippet.hide
print(String(component))
