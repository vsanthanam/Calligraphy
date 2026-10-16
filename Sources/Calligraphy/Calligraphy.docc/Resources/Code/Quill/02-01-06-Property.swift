import Calligraphy
import Manuscript

struct Property: StringComponent {

    let field: Field

    var body: some StringComponent {
        Line {
            "let \(field.name): \(field.type.swiftName)"
            if field.isOptional {
                "?"
            }
        }
    }

}
