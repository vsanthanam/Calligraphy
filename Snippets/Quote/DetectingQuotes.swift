// Read the `isInQuote` environment value to change how a component renders
// when it is wrapped in a `Quote`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.is-in-quote
struct Greeting: StringComponent {

    @StringEnvironment(\.isInQuote)
    private var isInQuote: Bool

    var body: some StringComponent {
        if isInQuote {
            "hello"
        } else {
            "Hello!"
        }
    }

}
// snippet.end

// snippet.hide
print(String(Greeting()))
print(String(Quote { Greeting() }))
