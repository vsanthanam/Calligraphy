import Manuscript

extension FieldType {

    var swiftName: String {
        switch self {
        case .string: "String"
        case .integer: "Int"
        case .double: "Double"
        case .boolean: "Bool"
        case let .array(element): "[\(element.swiftName)]"
        case let .reference(name): name
        }
    }

}
