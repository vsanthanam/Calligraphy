import Calligraphy
import Manuscript

struct TypeDeclaration: StringComponent {

    let type: TypeDefinition

    var body: some StringComponent {
        switch type.shape {
        case let .structure(fields):
            StructDeclaration(type: type, fields: fields)
        case let .enumeration(cases):
            EnumDeclaration(type: type, cases: cases)
        }
    }

}
