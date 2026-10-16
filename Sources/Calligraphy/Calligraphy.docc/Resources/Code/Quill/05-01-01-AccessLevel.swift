import ArgumentParser

enum AccessLevel: String, CaseIterable, ExpressibleByArgument {
    case `internal`
    case `public`
}
