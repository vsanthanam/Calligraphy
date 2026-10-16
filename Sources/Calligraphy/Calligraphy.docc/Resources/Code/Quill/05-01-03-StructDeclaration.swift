import Calligraphy
import Manuscript

struct StructDeclaration: StringComponent {

    let type: TypeDefinition
    let fields: [Field]

    @Environment(\.accessLevel)
    private var accessLevel

    var body: some StringComponent {
        if let documentation = type.documentation {
            Lines {
                documentation
            }
            .prefixLines(with: "/// ")
        }
        Line {
            if accessLevel == .public {
                "public "
            }
            "struct \(type.name): Codable {"
        }
        Lines {
            ForEach(fields) { field in
                Property(field: field)
            }
        }
        .tabbed()
        "}"
    }

}
