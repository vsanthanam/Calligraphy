// Define custom environment values with `@Entry`, and set them with
// `environment(_:_:)` and `transformEnvironment(_:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.entry
extension EnvironmentValues {

    @Entry
    public var prefix: String = "•"

}
// snippet.end

// snippet.optional-entry
extension EnvironmentValues {

    @Entry
    public var caption: String?

}
// snippet.end

// snippet.read-entry
struct ListItem: StringComponent {

    @Environment(\.prefix)
    private var prefix: String

    let text: String

    var body: some StringComponent {
        "\(prefix) \(text)"
    }

}
// snippet.end

// snippet.line-spacing
let component = Lines {
    "foo"
    "bar"
    "baz"
}
.lineSpacing(2)
// snippet.end

// snippet.environment
let item = ListItem(text: "foo")
    .environment(\.prefix, "→")
// snippet.end

// snippet.transform-environment
let transformed = ListItem(text: "foo")
    .transformEnvironment { environment in
        environment.prefix = "→"
        environment.caption = "Important"
    }
// snippet.end

// snippet.hide
print(String(component))
print(String(ListItem(text: "foo")))
print(String(item))
print(String(transformed))
