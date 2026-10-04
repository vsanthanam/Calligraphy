// Read values from the string environment with `@StringEnvironment` and `ReadEnvironment`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.property-wrapper
struct ListItem: StringComponent {

    @StringEnvironment(\.lineSpacing)
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

// snippet.read-environment
let component = ReadEnvironment { environment in
    if environment.lineSpacing > 1 {
        "spaced"
    } else {
        "tight"
    }
}
// snippet.end

// snippet.hide
print(String(ListItem(text: "foo")))
print(String(ListItem(text: "foo").lineSpacing(2)))
print(String(component))
print(String(component.lineSpacing(2)))
