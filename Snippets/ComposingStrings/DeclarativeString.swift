// Compose a multi-line string from components and plain strings with `String.init(builder:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.string-build
let declarativeString = String {
    Line {
        "Hello"
        Space()
        "World"
    }
    "Welcome to Calligraphy!"
}
// snippet.end

// snippet.hide
print(declarativeString)
