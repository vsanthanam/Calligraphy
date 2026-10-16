import Calligraphy
import Manuscript

struct EnumDeclaration: StringComponent {

    let type: TypeDefinition
    let cases: [String]

    @AccessModifier
    private var access

    var body: some StringComponent {
        "\(access)enum \(type.name): String, Codable {"
        Lines {
            ForEach(cases) { name in
                Line {
                    "case \(name) = "
                    Quote(name)
                }
            }
        }
        .tabbed()
        "}"
    }

}
