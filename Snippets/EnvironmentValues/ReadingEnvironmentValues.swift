// Read values from the environment with `@Environment`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.property-wrapper
struct ListItem: StringComponent {

    @Environment(\.lineSpacing)
    private var spacing: Int

    let text: String

    var body: some StringComponent {
        if spacing > 1 {
            "• \(text)"
        } else {
            "- \(text)"
        }
    }

}
// snippet.end

// snippet.hide
print(String(ListItem(text: "foo")))
print(String(ListItem(text: "foo").lineSpacing(2)))
