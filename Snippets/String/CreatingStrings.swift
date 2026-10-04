// Create a Swift `String` from a single string component, or from several
// combined components with `String.build(_:)`.

// snippet.hide
import Calligraphy

struct Greeting: StringComponent {

    var body: some StringComponent {
        "Hello, World!"
    }

}

// snippet.show
// snippet.component
let component = Greeting()
let string = String(component)
// snippet.end

// snippet.build
let built = String.build {
    "Hello, World!"
    "This is a declarative, multi-line string"
    "Created with Calligraphy!"
}
// snippet.end

// snippet.hide
print(string)
print(built)
