// Define an environment value by hand with `EnvironmentKey`, then read and set it by key type.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.key
struct IndentationKey: EnvironmentKey {
    static let defaultValue: Int = 4
}
// snippet.end

// snippet.read-key
struct Indented: StringComponent {

    @Environment(IndentationKey.self)
    private var indentation: Int

    let text: String

    var body: some StringComponent {
        String(repeating: " ", count: indentation) + text
    }

}
// snippet.end

// snippet.set-key
let component = Indented(text: "foo")
    .environment(IndentationKey.self, 2)
// snippet.end

// snippet.hide
print(String(Indented(text: "foo")))
print(String(component))
