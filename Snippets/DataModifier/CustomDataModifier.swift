// Package a reusable transformation as a `DataModifier`, then expose it as a
// method on `DataComponent` so it reads like a built-in modifier.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.modifier
struct NullTerminated: DataModifier {

    func body(content: Content) -> some DataComponent {
        content
        0x00
    }

}
// snippet.end

// snippet.extension
extension DataComponent {

    func nullTerminated() -> some DataComponent {
        modifier(NullTerminated())
    }

}
// snippet.end

// snippet.hide
let component = DataComponents {
    Data("hello".utf8)
}
.nullTerminated()

print(Array(Data(component)))
