// Implement `body` to define a `StringComponent`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.greeting
struct Greeting: StringComponent {

    let name: String

    var body: some StringComponent {
        "Hello, " + name + "!"
    }

}
// snippet.end

// snippet.hide
print(String(Greeting(name: "World")))
