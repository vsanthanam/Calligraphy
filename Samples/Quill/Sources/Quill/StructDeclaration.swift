import Calligraphy
import Manuscript

struct StructDeclaration: StringComponent {

    let type: TypeDefinition
    let fields: [Field]

    @AccessModifier
    private var access

    var body: some StringComponent {
        if let documentation = type.documentation {
            Lines {
                documentation
            }
            .prefixLines(with: "/// ")
        }
        "\(access)struct \(type.name): Codable {"
        Lines {
            ForEach(fields) { field in
                Property(field: field)
            }
        }
        .tabbed()
        "}"
    }

}
