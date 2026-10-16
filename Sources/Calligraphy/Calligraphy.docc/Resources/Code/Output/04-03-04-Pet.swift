/// A pet in the store.
struct Pet: Codable {
    let id: Int
    let name: String
    let status: Status?
    let tags: [String]
}
