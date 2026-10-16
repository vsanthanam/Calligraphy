import Calligraphy
import Manuscript

struct StructDeclaration: StringComponent {

    let type: TypeDefinition
    let fields: [Field]

    var body: some StringComponent {
        "struct \(type.name): Codable {"
        Lines {
            ForEach(fields) { field in
                "let \(field.name): \(field.type.swiftName)"
            }
        }
        "}"
    }

}
