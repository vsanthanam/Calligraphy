// Create reusable string components by implementing `body`, then compose them together.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.greeting
struct Greeting: StringComponent {

    var body: some StringComponent {
        "Hello, World!"
    }

}
// snippet.end

// snippet.welcome-message
struct WelcomeMessage: StringComponent {

    var body: some StringComponent {
        Lines {
            "Welcome to Calligraphy!"
            "This is a multi-line message."
            "Each line is a separate component."
            Greeting()
        }
    }

}
// snippet.end

// snippet.hide
print(String(WelcomeMessage()))
