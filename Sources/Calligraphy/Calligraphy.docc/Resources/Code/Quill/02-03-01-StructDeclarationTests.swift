import Calligraphy
import Manuscript
@testable import Quill
import Testing

struct StructDeclarationTests {

    private let fields = [
        Field(name: "id", type: .integer),
        Field(name: "name", type: .string),
        Field(name: "status", type: .reference("Status"), isOptional: true),
    ]

    private var pet: TypeDefinition {
        TypeDefinition(name: "Pet", documentation: "A pet in the store.", shape: .structure(fields))
    }

    @Test
    func declaresAStruct() {
        let declaration = StructDeclaration(type: pet, fields: fields)
        #expect(String(declaration) == """
        /// A pet in the store.
        struct Pet: Codable {
          let id: Int
          let name: String
          let status: Status?
        }
        """)
    }

}
