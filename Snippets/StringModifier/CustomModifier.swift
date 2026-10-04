// Package a reusable transformation as a `StringModifier`, then expose it as a
// method on `StringComponent` so it reads like a built-in modifier.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.modifier
struct Commented: StringModifier {

    func body(content: Content) -> some StringComponent {
        content
            .prefixLines(with: "// ")
    }

}
// snippet.end

// snippet.extension
extension StringComponent {

    func commented() -> some StringComponent {
        modifier(Commented())
    }

}
// snippet.end

// snippet.hide
let component = Lines {
    "This block is a comment."
    "Every line is prefixed."
}
.commented()

print(String(component))
