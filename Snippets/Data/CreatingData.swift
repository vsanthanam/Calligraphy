// Create Foundation `Data` from a single data component, or from several
// combined components with `Data.init(builder:)`.

// snippet.hide
import Calligraphy
import Foundation

struct Header: DataComponent {

    var body: some DataComponent {
        0x01 // Version
        0x02 // Flags
    }

}

// snippet.show
// snippet.component
let component = Header()
let data = Data(component)
// snippet.end

// snippet.build
let built = Data {
    Header()
    Data("payload".utf8)
}
// snippet.end

// snippet.hide
print(Array(data))
print(Array(built))
