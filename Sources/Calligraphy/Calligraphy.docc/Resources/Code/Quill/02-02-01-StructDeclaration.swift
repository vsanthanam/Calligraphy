import Calligraphy
import Manuscript

struct StructDeclaration: StringComponent {

    let type: TypeDefinition
    let fields: [Field]

    var body: some StringComponent {
        if let documentation = type.documentation {
            "/// \(documentation)"
        }
        "struct \(type.name): Codable {"
        Lines {
            ForEach(fields) { field in
                Property(field: field)
            }
        }
        .tabbed()
        "}"
    }

}
