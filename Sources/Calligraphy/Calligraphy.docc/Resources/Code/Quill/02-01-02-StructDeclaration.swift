import Calligraphy
import Manuscript

struct StructDeclaration: StringComponent {

    let type: TypeDefinition
    let fields: [Field]

    var body: some StringComponent {
        "struct \(type.name): Codable {"
        "}"
    }

}
