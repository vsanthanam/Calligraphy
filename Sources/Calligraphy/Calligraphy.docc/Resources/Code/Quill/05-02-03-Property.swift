import Calligraphy
import Manuscript

struct Property: StringComponent {

    let field: Field

    @AccessModifier
    private var access

    var body: some StringComponent {
        Line {
            "\(access)let \(field.name): \(field.type.swiftName)"
            if field.isOptional {
                "?"
            }
        }
    }

}
