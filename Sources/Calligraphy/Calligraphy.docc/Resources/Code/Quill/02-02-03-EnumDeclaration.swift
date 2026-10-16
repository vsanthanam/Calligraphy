import Calligraphy
import Manuscript

struct EnumDeclaration: StringComponent {

    let type: TypeDefinition
    let cases: [String]

    var body: some StringComponent {
        "enum \(type.name): String, Codable {"
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
