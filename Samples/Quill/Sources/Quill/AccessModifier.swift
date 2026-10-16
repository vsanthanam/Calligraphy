import Calligraphy

@propertyWrapper
struct AccessModifier: DynamicProperty {

    @Environment(\.accessLevel)
    private var accessLevel

    var wrappedValue: String {
        accessLevel == .public ? "public " : ""
    }

}
