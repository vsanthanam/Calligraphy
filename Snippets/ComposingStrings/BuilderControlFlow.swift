// Use control flow statements and `ForEach` inside a `@StringBuilder` function.

// snippet.hide
import Calligraphy

struct User {
    let name: String
    let isNew: Bool
}

struct Feature {
    let name: String
}

let availableFeatures = [
    Feature(name: "String composition"),
    Feature(name: "Directory composition"),
    Feature(name: "Data composition")
]

// snippet.show
// snippet.generate-message
@StringBuilder
func generateMessage(for user: User?) -> some StringComponent {
    if let user {
        "Hello, \(user.name)!"
        if user.isNew {
            "Welcome to our platform!"
        }
    } else {
        "Hello, Guest!"
    }

    ForEach(availableFeatures) { feature in
        "• \(feature.name)"
    }
}
// snippet.end

// snippet.hide
print(String(generateMessage(for: User(name: "Ada", isNew: true))))
print(String(generateMessage(for: nil)))
