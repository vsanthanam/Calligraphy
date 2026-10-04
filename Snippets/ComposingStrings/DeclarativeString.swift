// Compose a multi-line string from components and plain strings with `String.build(_:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.string-build
let declarativeString = String.build {
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
